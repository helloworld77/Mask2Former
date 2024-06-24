## install ## https://github.com/facebookresearch/Mask2Former/blob/main/INSTALL.md
###
 # @Author: error: error: git config user.name & please set dead value or install git && error: git config user.email & please set dead value or install git & please set dead value or install git
 # @Date: 2024-06-16 12:56:54
 # @LastEditors: error: error: git config user.name & please set dead value or install git && error: git config user.email & please set dead value or install git & please set dead value or install git
 # @LastEditTime: 2024-06-23 10:50:26
 # @FilePath: /projects/Mask2Former/note.sh
 # @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
### 
cp -r /home/wangchen/.conda/envs/yolov5 /home/wangchen/.conda/envs/mask2former
git clone https://mirror.ghproxy.com/https://github.com/facebookresearch/detectron2.git /home/ssd500g/wangchen/projects/detectron2
cd /home/ssd500g/wangchen/projects/detectron2
pip install -e .
pip install git+https://mirror.ghproxy.com/https://github.com/cocodataset/panopticapi.git
pip install git+https://mirror.ghproxy.com/https://github.com/mcordts/cityscapesScripts.git

git clone https://mirror.ghproxy.com/https://github.com/facebookresearch/Mask2Former.git /home/ssd500g/wangchen/projects/Mask2Former
cd /home/ssd500g/wangchen/projects/Mask2Former
pip install -r requirements.txt
cd mask2former/modeling/pixel_decoder/ops
sh make.sh
pip install setuptools==59.5.0

## data prepare ## https://github.com/facebookresearch/Mask2Former/blob/main/datasets/README.md
cd /home/ssd500g/wangchen/projects/Mask2Former
ln -s /home/ssd500g/wangchen/datasets/Cityscapes datasets
git clone https://mirror.ghproxy.com/https://github.com/mcordts/cityscapesScripts.git /home/ssd500g/wangchen/projects/cityscapesScripts
CITYSCAPES_DATASET=datasets/cityscapes python /home/ssd500g/wangchen/projects/cityscapesScripts/cityscapesscripts/preparation/createTrainIdLabelImgs.py
CITYSCAPES_DATASET=datasets/cityscapes python /home/ssd500g/wangchen/projects/cityscapesScripts/cityscapesscripts/preparation/createPanopticImgs.py

## start
cd /home/ssd500g/wangchen/projects/Mask2Former
mkdir ckpts
###### 测试Cityscapes Model Zoo - R50 ，注意区分Panoptic 、Instance、Semantic三类Segmentation ######
wget https://dl.fbaipublicfiles.com/maskformer/mask2former/cityscapes/panoptic/maskformer2_R50_bs16_90k/model_final_4ab90c.pkl
## infer
cd demo/
/home/wangchen/.conda/envs/mask2former/bin/python demo.py --config-file ../configs/cityscapes/panoptic-segmentation/maskformer2_R50_bs16_90k.yaml \
  --input test_data/input_cityscapes.png --output ../outputs/ \
  --opts MODEL.WEIGHTS ../ckpts/model_final_4ab90c.pkl
## train
python train_net.py --config-file configs/cityscapes/panoptic-segmentation/maskformer2_R50_bs16_90k.yaml --num-gpus 1 SOLVER.IMS_PER_BATCH 16 SOLVER.BASE_LR 0.0001
python train_net.py --config-file configs/cityscapes/panoptic-segmentation/maskformer2_dsconv_bs16_90k.yaml --num-gpus 1 SOLVER.IMS_PER_BATCH 4 SOLVER.BASE_LR 0.0001

# swin: wget https://mirror.ghproxy.com/https://github.com/SwinTransformer/storage/releases/download/v1.0.0/swin_tiny_patch4_window7_224.pth
python train_net.py --config-file configs/cityscapes/panoptic-segmentation/swin/maskformer2_swin_tiny_bs16_90k.yaml --num-gpus 1 SOLVER.IMS_PER_BATCH 2 SOLVER.BASE_LR 0.000025 MODEL.WEIGHTS ckpts/swin_tiny_patch4_window7_224.pth


  # SOLVER.IMS_PER_BATCH SET_TO_SOME_REASONABLE_VALUE SOLVER.BASE_LR SET_TO_SOME_REASONABLE_VALUE

## 修改加入dscnet https://github.com/YaoleiQi/DSCNet/blob/main/DSCNet_2D_opensource/Code/DRIVE/DSCNet/S3_DSConv.py
##               https://github.com/YaoleiQi/DSCNet/blob/main/DSCNet_2D_opensource/Code/DRIVE/DSCNet/S3_DSCNet.py
### 重点修改 init和output_shape