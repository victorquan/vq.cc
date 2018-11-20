---
title: php共享内存shmop和shm使用的一些坑
date: 2018-11-20 10:24:11
cover:
tags: [共享内存,shmop,shm]
---

最近在接入service mesh时，由于涉及底层接口高访问量的场景，考虑到性能问题需将mesh的地址缓存起来，首先想到了使用共享内存。
我们知道关于共享内存的操作，php有两套内置扩展函数shmop和sysvshm，一开始我采用了shmop扩展，业务在线上跑了半个多月均无任何异常出现，直到20天之后开始出现一些零星的异常，捕捉到的错误信息如下：
``` 
PHP Warning 'yii\base\ErrorException' with message 'shmop_delete() expects parameter 1 to be long, string given' in test.php 
```

其中写共享内存的php代码实现如下：
```php
    public function write($data){
        $data = pack('a*', $data);
        shmop_delete($this->shmId);
        shmop_close($this->shmId);
        $this->shmId = shmop_open($this->key, 'c', $this->perms, strlen($data));
        return shmop_write($this->shmId, $data, 0);
    }
```
由于shmop扩展函数在插入、更新、读取等操作均需要自行规划和管理共享内存的存储结构，比如使用shmop开辟一块共享内存并写入内容："abcdefghijklmn"，第二次写入："123456"，则此时共享内存的内容为"123456ghijklmn"，第二次的写入并不会清空共享内存已有的内容，所以当初图方便在每次写入时先删掉原来的共享内存块，重新创建一块内存地址并写入新内容，这就为高并发场景下出现以上错误埋下了伏笔。
原因找到了，于是我想到了改成使用sysvshm那套扩展，具体实现如下：
```php
    public function write($varKey, $data){
        $data = pack('a*', $data);
        return shm_put_var($this->shmId, $varKey, $data);
    }
```
第二天凌晨，收到了一大波告警，捕捉到的异常信息如下：
```
shm_put_var(): not enough shared memory left
```
并且php-fpm一直core，于是立马关掉使用共享内存的开关，经过两天的排查，终于在测试环境复现了问题。
复现方式，通过一个crontab开多个进程同时操作共享内存，一分钟之后，开始出现了同样的错误。于是停止脚本，发现无法通过shm_get_var()来读取共享内存的内容，于是我使用shmop_read读取到的内容如下图所示：
![shm_put_var错误](/img/shm-error.png)
写的内容只有：{"zmq":{"host":"19.168.1.100","port":"8899","createTime":1542110838}}，但是共享内存里面却是重复的内容，经过分析sysV的接口对于shareKey没有做去重处理，每次都写入了新的key，导致了共享内存的写入指针尽管是相同的shareKey但不断后移，最终导致共享内存被写爆。
于是在操作共享内存的地方都加上信号锁，经过验证再也不会出现以上问题。代码如下：
```php
    public function write($varKey, $data){
        $data = pack('a*', $data);
        $signal = sem_get($this->key);
        sem_acquire($signal);
        $result = shm_put_var($this->shmId, $varKey, $data);
        sem_release($signal);
        return $result;
    }
```

补充：
后来想起了补丁shmop版，其实可以自行进行存储空间管理，再加上信号锁，应该是可以完美解决问题的（以下代码未经过测试）：
```php
    public function write($data){
        $dataLength = strlen($data);
        $msg = pack('n', $dataLength);
        $msg .= pack('a', $data);
        $signal = sem_get($this->key);
        sem_acquire($signal);
        $result = shmop_write($this->shmId, $msg, 0);
        sem_release($signal);
        return $result;
    }
    
    public function read(){
        try{
            $size = shmop_size($this->shmId);
            $signal = sem_get($this->key);
            sem_acquire($signal);
            $shmContent = shmop_read($this->shmId, 0, $size);
            sem_release($signal);
            $dataInfo = unpack('n1dataLength', $shmContent);
            $data = unpack("n1dataLength/a{$dataInfo['dataLength']}data", $shmContent);
            return $data['data'];
        }catch(\Exception $e){
            return null;
        }
    }
```

最后还是推荐使用sysvshm那套API，比shmop要好用一些。



感谢：[https://www.jianshu.com/p/a182bc8b3f23](https://www.jianshu.com/p/a182bc8b3f23)





