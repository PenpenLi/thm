module("UI", package.seeall)

function newMenu(params)
    params = params or {}
    
    local label = THSTG.UI.newLabel(params)

    return label
end