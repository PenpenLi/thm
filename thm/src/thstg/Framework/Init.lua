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

 --常规全局
 require "thstg.Framework.Common.Init"
 
 --组件
 require "thstg.Framework.Component.Init"
 
 --MVC
 require "thstg.Framework.MVC.Init"
 
 --辅助库
 require "thstg.Framework.Util.StringUtil"
 require "thstg.Framework.Util.FileUtil"
 require "thstg.Framework.Util.TableUtil"
 require "thstg.Framework.Util.TimeUtil"
 require "thstg.Framework.Util.UIDUtil"
 require "thstg.Framework.Util.NodeUtil"