module("UI", package.seeall)

function newImage(params)
    params = params or {}
    
    local image = THSTG.UI.newImage(params)

    return image
end