# Claude Codeを利用して、#serverを使用しないように書き換えたバージョン

## main.csp

axiosを使用して通信する

## Shop.AddEntry.cls

標準REST APIではCSPと％sessionデータを共有できないため、%CSP.Pageを継承したクラスで処理を実装
