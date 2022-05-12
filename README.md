# TigerToken
TigerToken

尚未測試智能合約


## 為本次開發智能合約
-  TigarCoin/TigarCoin.sol

## 為測試輸入智能合約
- TigerToken/TigarCoin/NinjaNFTs/ninjaNFT.sol
- TigerToken/TigarCoin/TigerNFT/TigerNFT.sol


## Hack md
https://hackmd.io/DgcQ80mdQZKRRdhbf8bSUA?view



# TigerCoin

## 2022-05-08

### Mod 提領

1. `Mod_withDraw` 中的 `require(ModSupply - amount > 0 ,"Insufficient withdrawal amount");` 在 50 萬被領完的時候不會正確 revert 錯誤訊息 `Insufficient withdrawal amount`，而是會以 `underflowed` 錯誤被駁回，因為 `ModSupply - amount > 0` 會變成負數。
2. 承以上，最後提領的金額加起來會超過 50 萬上限的時候，也會提領失敗。例如：`ModSupply` 剩下 `1250` 可以提領，但是有一個地址Ａ累積了兩個月的額度來一次提領 2500，由於 1250 - 2500 會變成負數，所以該地址Ａ會提領失敗

### Tiger 空投提領

1. `Claim_Tiger_Token()` 中只有檢查 `if(tokenId <= 20)`，但是 tokenId `0` 是[有 owner 的](https://opensea.io/assets/0x2f224AE9323f5dF323d2A079833edA5C891D1510/0)，是否要加入判斷 `tokenId > 0` 阻擋

### DAO 提領

1. 功能確認：**可以每個月分月提領**，也可以45個月後一次提領，若累積兩個月提領可以一次提領兩月的份額
2. 目前寫法每個月會提領 `1066666.666666666666666666` 萬，並且過了45個月之後，總共會提領 `47999999.99999999999999997`，DAO 地址會擁有 `50999999.99999999999999997` 個代幣，**與預期不符**
3. 承以上，問題可能是因為 `Check_Dao_withDraw_Amount` 中的 `withDrawAmount = (DAO_Balance / 45) * withDrawAmount;` 使用 `DAO_Balance` 除以 45 個月，這疑似是參數誤用。`DAO_Balance` 紀錄的是 DAO 地址 4800 萬總份額，而不是總鎖倉金額 4500 萬。

### 其他不重要的建議：

若鎖倉智能合約要設計得「可被測試」，建議將大部分的地址設定寫在 deploy 時傳入 (`constructor`)，這樣測試時可以在「不更動合約任何程式碼」的前提下，產生臨時私鑰地址傳入或是動態設定合約地址。