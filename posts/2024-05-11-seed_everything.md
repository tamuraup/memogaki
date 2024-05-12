---
title: PyTorch 学習結果の再現性確保
date: 2024-05-11 06:35
categories: [ml]
---

Pytorch Lightning で学習したとき、[`seed_everything`](https://pytorch-lightning.readthedocs.io/en/1.7.7/api/pytorch_lightning.utilities.seed.html#pytorch_lightning.utilities.seed.seed_everything) で乱数固定すれば、同じ学習結果が得られると思っていたが実際にはそうでなかった。

調べてみると、

- `torch.backends.cudnn.benchmark`
- `torch.backends.cudnn.deterministic`

の設定も必要そうだった。[Reproducibility — PyTorch 2.3 documentation](https://pytorch.org/docs/stable/notes/randomness.html#cuda-convolution-benchmarking)  
この 2 つを設定することで、内部で使用されるアルゴリズムを固定化できるとのこと。

上記参考に以下の関数を呼ぶことで、同じ学習結果が得られるようになった。

```python
import torch
import lightning as pl

def seed_everything(seed):
    torch.backends.cudnn.benchmark = False
    torch.backends.cudnn.deterministic = True
    pl.seed_everything(seed)
```


## その他参考

- https://qiita.com/north_redwing/items/1e153139125d37829d2d#cuda-convolution-benchmarking
