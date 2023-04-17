local yieldout = {}
yieldout.__index = yieldout

local insert = table.insert;
local remove = table.remove;
local wrap = coroutine.wrap;
local yield = coroutine.yield;
local running = coroutine.running;
local resume = coroutine.resume;
local pack = table.pack;
local tunpack = table.unpack;

local states = {
    Running = 0,
    Succeded = 1,
    Timeouted = 2,
    Errored = 3
}
yieldout.StateEnum = states

-- return results, without succeed / failed information (pcall header)
function yieldout:__unpack()
    local result = self.__result
    if result.n-1 == 0 then return end -- no return values
    return unpack(result,2,result.n)
end

function yieldout:__warp(...)
    self.__result = pack(pcall(self.__func,...))
    if self.State == states.Timeouted then
    end
end

function yieldout:OnTimeout(func)
    if self.onTimeout then
        error("this yieldout has OnTimeout binding already!")
    end
    self.onTimeout = func
    if self.State == states.Timeouted then
        func()
    end
    return self
end

function yieldout:OnError(func)
    if self.onError then
        error("this yieldout has OnError binding already!")
    end
    self.onError = func
    if self.State == states.Errored then
        func(self:__unpack())
    end
    return self
end

function yieldout:AndThen(func)
    
    return self
end
-- end

-- HasError
-- HasTimeouted

function yieldout.New(timeout,func,...)
    local thisThread = running()
	if not thisThread then
		error("yieldout.New() must be runned on thread")
	end

    local this = { __func = func, State = states.Running }
    setmetatable(this,yieldout)
    wrap(yieldout.__warp)(this,...)
    yield()
    return this
end


return yieldout
