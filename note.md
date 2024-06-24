
## swin 输入：512x1024， 输出形状：
{'res2': ShapeSpec(channels=96, height=None, width=None, stride=4),   torch.Size([1, 96, 128, 256])
 'res3': ShapeSpec(channels=192, height=None, width=None, stride=8),  torch.Size([1, 192, 64, 128])
 'res4': ShapeSpec(channels=384, height=None, width=None, stride=16), torch.Size([1, 384, 32, 64])
 'res5': ShapeSpec(channels=768, height=None, width=None, stride=32)} torch.Size([1, 768, 16, 32])

 ## DSC 输入：512x1024， 
 输出调整：
    x_2_1 torch.Size([1, 64, 128, 256])
    x_3_1 torch.Size([1, 128, 64, 128])