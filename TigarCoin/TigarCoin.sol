// SPDX-License-Identifier: MIT
// import ERC-20
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";


pragma solidity ^0.8.0;


contract CollectionNFT{

    function spand(uint256 Total,uint256 Proportion)public pure returns(uint256){
        uint256 share = Total / 10000;

        return share * Proportion;
    }

    uint256 public timeLock;

    address public devAddress;

    address public constant CyberNinja_NFT = 0x3d6ab55fB262f786ba1e9d1172657FB2d462F1f8;
    IERC721 public Ninja;
    IERC721Enumerable public NinjaEnu;

    address public constant SuperStarTiger_NFT = 0x2f224AE9323f5dF323d2A079833edA5C891D1510;
    IERC721 public Tiger;
    IERC721Enumerable public TigerEnu;

    constructor(){
        devAddress = msg.sender;
        timeLock = block.timestamp;
        Ninja = IERC721(CyberNinja_NFT);
        Tiger = IERC721(SuperStarTiger_NFT);
        NinjaEnu = IERC721Enumerable(CyberNinja_NFT);
        TigerEnu = IERC721Enumerable(SuperStarTiger_NFT);
    }

    //Cyper Ninja NFT
    uint256[] private Rare_Ninja = [184,1438,2096,2469,4188,4548];
    uint256 private Rare_balance = 560;
    uint256 private normal_balance = 20;

    mapping(uint256 => uint256)public Ninja_withDraw;//by ID

    // Superstar Tiger NFT TokenID
    uint32 private Diamond = 20; // 1-20
    uint32 private Platinum = 100; // 21 - 100
    uint32 private Gold = 338; // 101 - 150

    uint256 private Diamond_balance = 1550;
    uint256 private Platinum_balance = 1500;
    uint256 private Gold_balance = 1000;

    mapping(uint256 => uint256)public Tiger_withDraw;//by ID
    mapping(uint256 => uint256)public DiamondTiger;
    mapping(uint256 => bool)public NinjaAirdrop;
    mapping(uint256 => bool)public TigerAirdrop;

    function setNftContract(address ninja,address Tigers)external{
        Ninja = IERC721(ninja);
        NinjaEnu = IERC721Enumerable(ninja);

        Tiger = IERC721(Tigers);
        TigerEnu = IERC721Enumerable(Tigers);

    }

    // time Count

    function checkTime() public view returns(uint256){
        return block.timestamp - timeLock;
    }

    function checkTimeByMonth() public view returns(uint256){
        return (block.timestamp - timeLock) / 30 days + 1 ;
    }

    function airdrop_Check(address user) public view returns(uint256){

        uint256 Token_Balance = 0;

         for(uint256 i=0;i<Ninja.balanceOf(user);i++){
            uint256 tokenId = NinjaEnu.tokenOfOwnerByIndex(user, i);
            bool RareNinja = false;
            for(uint8 a=0;a<Rare_Ninja.length;a++){
                if(tokenId == Rare_Ninja[a]){
                    RareNinja = true;
                }
            }


            if(RareNinja && !NinjaAirdrop[tokenId]){
                Token_Balance +=  1150;

            }else if(!NinjaAirdrop[tokenId]){
                Token_Balance += 50;
            }

        }



        for(uint256 i=0;i<Tiger.balanceOf(user);i++){
            uint256 tokenId = TigerEnu.tokenOfOwnerByIndex(user, i);


            if(tokenId <= 20 && !TigerAirdrop[tokenId]  ){
                Token_Balance += 2000;
            }else if(tokenId <= 100 && !TigerAirdrop[tokenId] ){
                Token_Balance += 1900;
            }else if(tokenId <= 338 && !TigerAirdrop[tokenId]){
                Token_Balance += 1500;
            }

        }

        return Token_Balance;


    }

    function airdropToken(address user) internal returns(uint256){

        uint256 Token_Balance = 0;

         for(uint256 i=0;i<Ninja.balanceOf(user);i++){
            uint256 tokenId = NinjaEnu.tokenOfOwnerByIndex(user, i);
            bool RareNinja = false;
            for(uint8 a=0;a<Rare_Ninja.length;a++){
                if(tokenId == Rare_Ninja[a]){
                    RareNinja = true;
                }
            }



            if(RareNinja && !NinjaAirdrop[tokenId]){
                Token_Balance +=  1150;

            }else if(!NinjaAirdrop[tokenId]){
                Token_Balance += 50;
            }

            NinjaAirdrop[tokenId] = true;

        }



        for(uint256 i=0;i<Tiger.balanceOf(user);i++){
            uint256 tokenId = TigerEnu.tokenOfOwnerByIndex(user, i);


            if(tokenId <= 20 && !TigerAirdrop[tokenId]  ){
                Token_Balance += 2000;
            }else if(tokenId <= 100 && !TigerAirdrop[tokenId] ){
                Token_Balance += 1900;
            }else if(tokenId <= 338 && !TigerAirdrop[tokenId]){
                Token_Balance += 1500;
            }

            TigerAirdrop[tokenId] = true;

        }

        return Token_Balance;


    }

    function Claim_Ninja_Token()internal returns(uint256){
        if(Ninja.balanceOf(msg.sender) == 0){
            return 0;
        }

        uint256 Token_Balance;

        for(uint256 i=0;i<Ninja.balanceOf(msg.sender);i++){
            uint256 tokenId = NinjaEnu.tokenOfOwnerByIndex(msg.sender, i);
            bool RareNinja = false;
            for(uint8 a=0;a<Rare_Ninja.length;a++){
                if(tokenId == Rare_Ninja[a]){
                    RareNinja = true;
                }
            }

            uint256 Withdrawal = checkTimeByMonth() - Ninja_withDraw[tokenId];

            if(Withdrawal + Ninja_withDraw[tokenId] >30){
                Withdrawal = 30 -  Ninja_withDraw[tokenId];
                Ninja_withDraw[tokenId] = 30;
            }else{
                Ninja_withDraw[tokenId] += Withdrawal;

            }




            if(RareNinja){
                Token_Balance += Withdrawal * Rare_balance;

            }else{
                Token_Balance += (Withdrawal * normal_balance);
            }

        }

        return Token_Balance;
    }

    function Check_Ninja_Token(address user)external view returns(uint256){//check Claim Balance
        if(Ninja.balanceOf(user) == 0){
            return 0;
        }

        uint256 Token_Balance = 0;

        for(uint256 i=0;i<Ninja.balanceOf(user);i++){
            uint256 tokenId = NinjaEnu.tokenOfOwnerByIndex(user, i);
            bool RareNinja = false;
            for(uint8 a=0;a<Rare_Ninja.length;a++){
                if(tokenId == Rare_Ninja[a]){
                    RareNinja = true;
                }
            }

            uint256 Withdrawal = checkTimeByMonth() - Ninja_withDraw[tokenId];

            if(Withdrawal + Ninja_withDraw[tokenId] >30){
                Withdrawal = 30 -  Ninja_withDraw[tokenId];
            }


            if(RareNinja){
                Token_Balance += Withdrawal * Rare_balance;

            }else{
                Token_Balance += (Withdrawal * normal_balance);
            }

       }



        return Token_Balance;
    }




    function Claim_Tiger_Token()internal returns(uint256){
        if(Tiger.balanceOf(msg.sender) == 0){
            return 0;
        }

        uint256 Token_Balance = 0;

        for(uint256 i=0;i<Tiger.balanceOf(msg.sender);i++){
            uint256 tokenId = TigerEnu.tokenOfOwnerByIndex(msg.sender, i);

            uint256 Withdrawal = checkTimeByMonth() - Tiger_withDraw[tokenId];

            if(Withdrawal+ Tiger_withDraw[tokenId] >30){
                Withdrawal = 30 -  Tiger_withDraw[tokenId];
                Tiger_withDraw[tokenId] = 30;
            }else{
                Tiger_withDraw[tokenId] += Withdrawal;

            }


            if(tokenId <= 20){
                Token_Balance += Withdrawal * Diamond_balance;
            }else if(tokenId <= 100){
                Token_Balance += Withdrawal * Platinum_balance;
            }else if(tokenId <= 338){
                Token_Balance += Withdrawal * Gold_balance;
            }

        }

        return Token_Balance;
    }

    function Check_Tiger_Token(address user)external view returns(uint256){//check Claim Balance
        if(Tiger.balanceOf(user) == 0){
            return 0;
        }

        uint256 Token_Balance = 0;

        for(uint256 i=0;i<Tiger.balanceOf(user);i++){
            uint256 tokenId = TigerEnu.tokenOfOwnerByIndex(user, i);

            uint256 Withdrawal = checkTimeByMonth() - Tiger_withDraw[tokenId];

            if(Withdrawal + Tiger_withDraw[tokenId] >30){
                Withdrawal = 30 -  Tiger_withDraw[tokenId];
            }

            if(tokenId <= 20){
                Token_Balance += Withdrawal * Diamond_balance;
            }else if(tokenId <= 100){
                Token_Balance += Withdrawal * Platinum_balance;
            }else if(tokenId <= 338){
                Token_Balance += Withdrawal * Gold_balance;
            }


        }

        return Token_Balance;
    }

      function ClaimDiamondTigerWithdraw()internal returns(uint256){
          if(Tiger.balanceOf(msg.sender) == 0){
            return 0;
        }

        uint256 Token_Balance = 0;

        for(uint256 i=0;i<Tiger.balanceOf(msg.sender);i++){
            uint256 tokenId = TigerEnu.tokenOfOwnerByIndex(msg.sender, i);

            uint256 Withdrawal = checkTimeByMonth() - DiamondTiger[tokenId];

            if(Withdrawal + DiamondTiger[tokenId] >25){
                Withdrawal = 25 -  DiamondTiger[tokenId];
                DiamondTiger[tokenId] = 25;
            }else{
                DiamondTiger[tokenId] += Withdrawal;
            }

            if(tokenId <= 20){
                Token_Balance += Withdrawal * 1000;
            }


        }

        return Token_Balance;
    }

    function DiamondTigerWithdraw(address user)public view returns(uint256){
          if(Tiger.balanceOf(user) == 0){
            return 0;
        }

        uint256 Token_Balance = 0;

        for(uint256 i=0;i<Tiger.balanceOf(user);i++){
            uint256 tokenId = TigerEnu.tokenOfOwnerByIndex(user, i);

            uint256 Withdrawal = checkTimeByMonth() - DiamondTiger[tokenId];

            if(Withdrawal + DiamondTiger[tokenId] >25){
                Withdrawal = 25 -  DiamondTiger[tokenId];
            }

            if(tokenId <= 20){
                Token_Balance += Withdrawal * 1000;
            }


        }

        return Token_Balance;
    }


}

contract Lockup is CollectionNFT{

    address public Project_Owner = 0x50C3ACba7A49667c3136310971f7c2bde3518490;
    address public Angel_Founder = 0xE6E4d986A24880CC23F393A1f4Db9dBbF75A3e4B;
    address public SuperStar_Tiger_Foundation = 0x8c30f38C9c710AAec22D8E7A265Cc7B306167CD5;

    mapping(address => bool)public Tiger_MOD;

    mapping(address => uint256)public WithdrawalAmount;
    mapping(address => uint256)public ModWithdrawal;
    mapping(address => uint256)public ModAddTime;
    uint256 public constant DAO_Balance = 45000000 * 1e18;//45 mounth

    uint256 private constant ModPay = 1250;

    function AddMOD(address[] memory Mods,bool change)external{
        require(msg.sender == devAddress || msg.sender == Project_Owner,"Not the owner of dev");

        for(uint256 a=0;a<Mods.length;a++){
            Tiger_MOD[Mods[a]] = change;

            if(change == true){
                ModAddTime[Mods[a]] = block.timestamp;
            }
        }


    }

    function MODtimer(address mod) public view returns(uint256){
        return (block.timestamp - ModAddTime[mod]) ;
    }

    function MOD_time(address mod) public view returns(uint256){
        return (block.timestamp - ModAddTime[mod]) / 30 days +1;
    }

    function Check_Dao_withDraw_Amount() public view returns(uint256){

        if(WithdrawalAmount[SuperStar_Tiger_Foundation] == 45){
            return 0;
        }

        uint256 withDrawAmount =  checkTimeByMonth() - WithdrawalAmount[SuperStar_Tiger_Foundation];

        if(withDrawAmount + WithdrawalAmount[SuperStar_Tiger_Foundation] >45){
            withDrawAmount = (45 - WithdrawalAmount[SuperStar_Tiger_Foundation]);
        }

        withDrawAmount = (DAO_Balance / 45) * withDrawAmount;

        return withDrawAmount;


    }



    function check_Mod_withDraw(address mod) public view returns(uint256){
        require(Tiger_MOD[mod],"not the Mod");
        uint256 withDrawAmount = MOD_time(mod) - ModWithdrawal[mod];

        withDrawAmount = withDrawAmount * ModPay;

        return withDrawAmount;

    }


}



contract TigerCoin is Lockup{
    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply = 100000000 * 1e18;//一億
    uint256 private ModSupply = 500000 * 1e18;

    string private _name = "Tiger coin";
    string private _symbol = "TGC";


    // address private Vitalik_Buterin = 0xAb5801a7D398351b8bE11C439e05C5B3259aeC9B;
    // address private Ethereum_Foundation = 0xde0B295669a9FD93d5F28D9Ec85E40f4cb697BAe;



    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor() {


        //DAO address
        _balances[SuperStar_Tiger_Foundation] = spand(_totalSupply,300);
        //Project Owner
        _balances[Project_Owner] = spand(_totalSupply,1850);
        //天使投資人
        _balances[Angel_Founder] = spand(_totalSupply,1700);
        //address this
        _balances[address(this)] = spand(_totalSupply,6150);


        emit Transfer(address(0),SuperStar_Tiger_Foundation, spand(_totalSupply,300));
        emit Transfer(address(0),Project_Owner, spand(_totalSupply,1850));
        emit Transfer(address(0),Angel_Founder,spand(_totalSupply,1700));
        emit Transfer(address(0),address(this),spand(_totalSupply,6150));

    }


    function name() public view  returns (string memory) {
        return _name;
    }


    function symbol() public view returns (string memory) {
        return _symbol;
    }


    function decimals() public pure returns (uint8) {
        return 18;
    }


    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }


    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }


    function transfer(address to, uint256 amount) public returns (bool) {
        address owner = msg.sender;
        _transfer(owner, to, amount);
        return true;
    }

    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }


    function approve(address spender, uint256 amount) public returns (bool) {
        address owner = msg.sender;
        _approve(owner, spender, amount);
        return true;
    }



    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public returns (bool) {
        address spender = msg.sender;
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }


    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        address owner = msg.sender;
        _approve(owner, spender, allowance(owner, spender) + addedValue);
        return true;
    }


    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        address owner = msg.sender;
        uint256 currentAllowance = allowance(owner, spender);
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked {
            _approve(owner, spender, currentAllowance - subtractedValue);
        }

        return true;
    }


    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");



        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            _balances[from] = fromBalance - amount;
        }
        _balances[to] += amount;

        emit Transfer(from, to, amount);


    }


    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");



        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);


    }


    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");



        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            _balances[account] = accountBalance - amount;
        }
        _totalSupply -= amount;

        emit Transfer(account, address(0), amount);


    }


    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }


    function _spendAllowance(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "ERC20: insufficient allowance");
            unchecked {
                _approve(owner, spender, currentAllowance - amount);
            }
        }
    }

    function Airdrop() external{
        require(Ninja.balanceOf(msg.sender) > 0 || Tiger.balanceOf(msg.sender) > 0 ,"Not enought Ninja");

        uint256 token = airdropToken(msg.sender);
        require(token > 0,"You can't claim the token");

        _transfer(address(this), msg.sender, token * 1e18);

    }




    function ClaimTigerToken() external{
        require(Ninja.balanceOf(msg.sender) > 0 || Tiger.balanceOf(msg.sender) > 0 ,"Not enought Ninja");

        uint256 Ninja_amount = Claim_Ninja_Token();
        uint256 Tiger_amount = Claim_Tiger_Token();

        if(Ninja_amount + Tiger_amount == 0){
            revert("Nothing to withdraw");
        }

        uint256 Total_amount = (Ninja_amount + Tiger_amount) * 1e18;


        _transfer(address(this), msg.sender, Total_amount);


    }

    function Dao_withDraw() external{
        require(msg.sender == SuperStar_Tiger_Foundation,"You are not the Foundation address");
        require(checkTimeByMonth() - WithdrawalAmount[SuperStar_Tiger_Foundation] > 0 ,"Not the time to withdraw");
        require(WithdrawalAmount[SuperStar_Tiger_Foundation] < 45 ,"With draw over");
        uint256 amount = Check_Dao_withDraw_Amount();

        if(amount == 0){
            revert("Claim is over");
        }

        WithdrawalAmount[SuperStar_Tiger_Foundation] += checkTimeByMonth() -  WithdrawalAmount[SuperStar_Tiger_Foundation];

        if(WithdrawalAmount[SuperStar_Tiger_Foundation] > 45){


            WithdrawalAmount[SuperStar_Tiger_Foundation] = 45;

            _transfer(address(this), msg.sender, amount);


        }else{

            _transfer(address(this), msg.sender, amount);

        }



    }



    function Mod_withDraw() external{
        require(Tiger_MOD[msg.sender],"You are not the Mod");


        uint256 amount = check_Mod_withDraw(msg.sender);

        ModWithdrawal[msg.sender] += (MOD_time(msg.sender) - ModWithdrawal[msg.sender]);



        if(amount == 0){
            revert("Nothing to withdraw");
        }

        require(ModSupply >= amount,"Withdrawal completed");
        require(ModSupply - amount > 0 ,"Insufficient withdrawal amount");

        ModSupply -= amount * 1e18;

        _transfer(address(this), msg.sender , amount * 1e18);

    }

    function aipdrop(address[] memory user,uint256 amouunt)external{

        for(uint256 a=0;a<user.length;a++){

            transfer(user[a],amouunt * 1e18);

        }
    }

      function DiamondWithdraw() external{
        require(Tiger.balanceOf(msg.sender) > 0 ,"Not enought Tiger");

        uint256 count = ClaimDiamondTigerWithdraw();

        require(count > 0,"You can't claim the token");

        _transfer(address(this), msg.sender, count * 1e18);



    }



    //view function

    function RemainingModToken() external view returns(uint256){
        return ModSupply;
    }





}