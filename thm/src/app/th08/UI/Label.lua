module("UI", package.seeall)

function newLabel(params)
    params = params or {}
    
    local label = THSTG.UI.newLabel(params)

    return label
end