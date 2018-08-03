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
 THSTG = THSTG or {}
 THSTG.EngineEx = require "thstg.Scripts.Framework.EngineEx"
 
 --常规全局
 require "thstg.Scripts.Framework.Common.Init"
 
 --组件
 require "thstg.Scripts.Framework.Component.Init"
 
 --MVC
 require "thstg.Scripts.Framework.MVC.Init"
 
 --UI库
 require "thstg.Scripts.Framework.UI.Init"
 
 --辅助库
 require "thstg.Scripts.Framework.Util.FileUtil"
 require "thstg.Scripts.Framework.Util.TableUtil"
 require "thstg.Scripts.Framework.Util.UIDUtil"
 