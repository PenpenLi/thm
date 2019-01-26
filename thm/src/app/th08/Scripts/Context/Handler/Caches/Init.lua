local _CACHES_ = 
{
    "Scripts.Context.Handler.Caches.Cache",
    "Scripts.Context.Handler.Caches.AnimationCache",
    "Scripts.Context.Handler.Caches.ObjectCache",









































    
}

---------------------------------------------------
for _,v in ipairs(_CACHES_) do
    require(v)
    CacheManager.register(v)
end