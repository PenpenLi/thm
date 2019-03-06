--[[
/**
 * @Author: cnscj 
 * @Version: v1.0 
 * @Date: 2018-06-27 12:07:21 
 * @Brief: THSTG库初始化加载
 * @Last Modified by: cnscj
 * @Last Modified time: 2018-06-27 13:23:09
 * @Last Modified log: 
 */
 ]]
--第三方库加载
require "thstg.Framework.Third.Init"

--辅助库
require "thstg.Framework.Util.Init"

--常规定义
require "thstg.Framework.Definition.Init"

--常规全局
require "thstg.Framework.Common.Init"
 
--组件
require "thstg.Framework.Component.Init"

--单例服务
require "thstg.Framework.Services.Init"

--管理器
require "thstg.Framework.Managers.Init"

--架构模式
require "thstg.Framework.Package.Init"

 --引擎驱动
require "thstg.Framework.Game"

