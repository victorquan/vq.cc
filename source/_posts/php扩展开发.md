---
title: php扩展开发
date: 2019-07-15 10:43:21
cover:
tags: [php扩展]
---


最近在做技术迁移时，遇到一种场景需要找出php代码中调用php内部函数 json_encode() 且入参为 proto 类实例的地方，因为php为动态语言，一个变量可以存储多种数据类型，并且可以在运行时发生变化，所以通过简单的静态扫描/IDE搜索是难以甚至无法找出来的。因此想到得编写一个php扩展，在php代码运行时拦截指定的方法并判断入参是否为某个类实例，进而打日志记录对应的调用处。

### 一、环境
```
php 5.6
gcc 4.4.7
CentOS release 6.8
```

### 二、生成项目结构
1、下载 [php5.6内核源码](https://github.com/php/php-src)
2、执行以下命令，生成项目结构：
```
./php-src/ext/ext_skel --skel=./php-src/ext/skeleton --extname=beach_php56
```
生成的项目结构如下图所示<br>
![项目结构](/img/php-so/beach_php56_project.png)

config.m4：UNIX构建系统配置，详见->[点我](https://www.php.net/manual/zh/internals2.buildsys.configunix.php)
config.w32：Windows构建系统配置，详见->[点我](https://www.php.net/manual/zh/internals2.buildsys.configwin.php)
beach_php56.c：主要的扩展源文件。
php_beach_php56.h：当将扩展作为静态模块构建并放入PHP二进制包时，构建系统要求用php_加扩展的名称命名的头文件包含一个对扩展模块结构的指针定义。就象其他头文件，此文件经常包含附加的宏、原型和全局量


### 三、编码
php扩展的生命周期参考下图：<br>
![php-so生命周期](/img/php-so/php_extensions_lifecycle.png)

源码详见：[beach_ph56源码](https://github.com/victorquan/beach_php56)


#### 修改beach_php56.c文件
1、定义钩子 hook_execute
```
void hook_execute(TSRMLS_D)
{
	//根据php.in设置判断是否启用拦截器
	if(BEACH_PHP56_G(global_interceptor_enable)){
		old_execute_internal = zend_execute_internal;
		if (old_execute_internal == NULL) {
			old_execute_internal = execute_internal;
		}
		zend_execute_internal = execute_function_interceptor;
	}
}
```

2、定义拦截器 execute_function_interceptor
```
static void execute_function_interceptor(zend_execute_data *execute_data_ptr, zend_fcall_info *fci, int return_value_used TSRMLS_DC)
{
	int ht;
	char *lcname;
	int function_name_strlen, free_lcname = 0;
	zend_class_entry *ce = NULL;
	zval *arg1;
	char *find_func_name = "json_encode";
	char *arg_class_prefix = "proto\\";

	ce = ((zend_internal_function *) execute_data_ptr->function_state.function)->scope;
	lcname = (char *)((zend_internal_function *) execute_data_ptr->function_state.function)->function_name;
	function_name_strlen = strlen(lcname);

	zend_op_array *op_array = execute_data_ptr->op_array;
	zend_arg_info *arg_info = ((zend_internal_function *) execute_data_ptr->function_state.function)->arg_info;
	zend_class_entry *scope = ((zend_internal_function *) execute_data_ptr->function_state.function)->scope;

	if(lcname && strstr(lcname, find_func_name) != NULL){
		if(zend_get_parameters(ZEND_NUM_ARGS(), 1, &arg1) == FAILURE){
			zend_error(E_ERROR, "cannot get arg1");
		}else{
			if(Z_TYPE_P(arg1) == IS_OBJECT){
				zend_class_entry *entry;
				entry = Z_OBJCE_P(arg1);
				if(entry->name && strstr(entry->name, arg_class_prefix) != NULL){
					zend_error(E_ERROR, "\nError Message：%s(line %d)", op_array->filename, execute_data_ptr->opline->lineno);
				}
			}
		}
	}

	old_execute_internal(execute_data_ptr, fci, return_value_used TSRMLS_CC);
	return;
}
```

3、在 PHP_MINIT_FUNCTION 函数中启动钩子
```
hook_execute(TSRMLS_C);
```


### 四、编译
1、修改php.ini配置，增加一行：
```
extension=beach_so.so
```

2、root权限执行以下命令进行编译
```
phpize
./configure
make
make install
killall php-fpm
```



