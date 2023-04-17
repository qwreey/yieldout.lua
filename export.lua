export errorString = string

export yieldout = {
    OnError: (self:yieldout,(errorString:errorString,...any)->())->yieldout;
    OnTimeout: (self:yieldout,()->())->yieldout;
    AndThen: (self:yieldout,(...any)->())->yieldout;
    HasError: (self:yieldout)->(boolean,errorString);
    HasTimeouted
    GetResults
}