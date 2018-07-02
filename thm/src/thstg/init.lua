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
THSTG.Game = require "thstg.Game"

--核心
require "thstg.core.THSTG"

--MVC
require "thstg.mvc.Init"

--通用库

--UI库
require "thstg.ui.Init"

--辅助库
require "thstg.utils.FileUtil"
require "thstg.utils.TableUtil"