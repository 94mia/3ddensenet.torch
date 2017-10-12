require 'nn'
require 'cunn'
require 'cudnn'

local function createModel(opt)
    local nClasses = opt.nClasses
    local net = nn.Sequential()
    
    net:add(nn.VolumetricConvolution(1,32,5,5,5,2,2,2,1,1,1))
    net:add(nn.LeakyReLU(0.1,true))
    -- net:add(nn.VolumetricDropout(0.2))
    net:add(nn.Dropout(0.2))
    
    net:add(nn.VolumetricConvolution(32,32,3,3,3,1,1,1))
    net:add(nn.LeakyReLU(0.1,true))
    net:add(nn.VolumetricMaxPooling(2,2,2))
    -- net:add(nn.VolumetricDropout(0.3))
    net:add(nn.Dropout(0.3))
    
    net:add(nn.View(6912))
    net:add(nn.Linear(6912,128))
    net:add(nn.ReLU(true))
    net:add(nn.Dropout(0.4))
    
    net:add(nn.Linear(128,nClasses))
    net:cuda()
    -- test net
    -- a=net:forward(torch.randn(1,1,30,30,30):cuda())
    a=net:forward(torch.randn(1,1,48,48,48):cuda())
    print(a:size())
    return net

end

return createModel
