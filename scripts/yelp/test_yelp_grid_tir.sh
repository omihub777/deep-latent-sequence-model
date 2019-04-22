#!/bin/bash
#SBATCH --gres=gpu:1
#SBATCH --mem=12g
#SBATCH -t 0
#SBATCH --array=1-1%1
##SBATCH --nodelist=compute-0-7

declare -a pool=("5" "3" "1")
declare -a klw=("0.08" "0.1" "0.15" "0.2")

arglen1=${#pool[@]}
arglen2=${#klw[@]}

taskid=${SLURM_ARRAY_TASK_ID}

i=$(( taskid/arglen2 ))
j=$(( taskid%arglen2 ))

python src/main.py \
  --dataset yelp \
  --clean_mem_every 5 \
  --reset_output_dir \
  --classifier_dir="pretrained_classifer/yelp" \
  --data_path data/test/ \
  --train_src_file data/yelp/train.txt \
  --train_trg_file data/yelp/train.attr \
  --dev_src_file data/yelp/dev.txt \
  --dev_trg_file data/yelp/dev.attr \
  --dev_trg_ref data/yelp/dev.txt \
  --src_vocab  data/yelp/text.vocab \
  --trg_vocab  data/yelp/attr.vocab \
  --d_word_vec=128 \
  --d_model=512 \
  --log_every=100 \
  --eval_every=3000 \
  --ppl_thresh=10000 \
  --eval_bleu \
  --batch_size 32 \
  --valid_batch_size 128 \
  --patience 5 \
  --lr_dec 0.8 \
  --lr 0.001 \
  --dropout 0.3 \
  --max_len 10000 \
  --seed 0 \
  --beam_size 1 \
  --word_blank 0. \
  --word_dropout 0. \
  --word_shuffle 0 \
  --cuda \
  --anneal_epoch 2 \
  --temperature 0.01 \
  --max_pool_k_size ${pool[i]} \
  --bt \
  --klw ${klw[j]} \
  --lm \
  --bt_stop_grad \
  --avg_len \
  # --gs_soft \