pragma solidity ^0.4.10;
contract drugcompany
{
    struct product
    {
        uint avail;
        uint threosold;
        uint rate;
    }
    mapping (uint => product)drugs;
    address drugmanager;
    address hospitalmanager;
    // uint public prodid=0;
    uint orderdid=0;
    struct order
    {
        uint hospid;
        uint time;
        uint drugid;
        uint quantity;
        uint amount;
    }
    mapping (uint => order)orders;
    uint [] hospitals;
    uint public income=0;
       struct patient
   {
       uint hospid;
   }
   struct patient_log
   {
       uint patientid;
       uint docid;
       uint timestamp;
       uint drugid;
       uint amount;
   }
   mapping (uint => patient) patients;
   mapping (uint => patient_log) logs;
   uint logid=1;
    modifier onlydm(address d)
    {
        require(d==drugmanager);
        _;
    }
    modifier onlyhm(address d)
    {
        require(d==hospitalmanager);
        _;
    }
    function drugcompany(address hm)
    {
        drugmanager=msg.sender;
        hospitalmanager=hm;
    }
    function reg_hos(uint y) public onlyhm(msg.sender)
    {
        hospitals.push(y);
    }
    function add_drug(uint p,uint a,uint t,uint r) public onlydm(msg.sender)
    {
       drugs[p].avail=a;
        drugs[p].threosold=t;
        drugs[p].rate=r;
        // prodid+=1;
    }
    function update_avail(uint pi,uint k) public onlydm(msg.sender)
    {
        drugs[pi].avail+=k;
    }
    function valid_hos(uint j) returns(bool)
    {
        uint flag=0;
        for(uint i=0;i<hospitals.length;i++)
        {
            if(hospitals[i]==j)
            {
                flag=1;
                return true;
            }
        }
        if (flag==0)
        {
            return false;
        }
    }
    modifier validhos(uint tr)
    {
        require(valid_hos(tr)==true);
        _;
    }
    modifier meetavail(uint hy,uint k)
    {
        require(hy<= drugs[k].avail);
        _;
    }
    modifier meetthros(uint k,uint hy)
    {
        require(hy< drugs[k].threosold);
        _;
    }
      function buy_drug (uint h,uint porid,uint req_amount,uint did,uint patid) public validhos(h) meetavail(req_amount,porid) meetthros(porid,req_amount)
    {
        drugs[porid].avail-=req_amount;
        income+=(req_amount*drugs[porid].rate);
        orders[orderdid].hospid=h;
        orders[orderdid].time=now;
        orders[orderdid].drugid=porid;
        orders[orderdid].quantity=req_amount;
        orders[orderdid].amount=req_amount*drugs[porid].rate;
        orderdid+=1;
       logs[logid].patientid=patid;
        logs[logid].docid=did;
        logs[logid].timestamp=now;
        logs[logid].drugid=porid;
        logs[logid].amount=req_amount;
        logid+=1;
    }
    function drug_av(uint pid) constant public returns(uint) 
    {
        return drugs[pid].avail;
    }
}
