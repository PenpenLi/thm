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
 
 --UI库
 require "thstg.Framework.UI.Init"
 
 --辅助库
 require "thstg.Framework.Util.FileUtil"
 require "thstg.Framework.Util.TableUtil"
 require "thstg.Framework.Util.UIDUtil"
 