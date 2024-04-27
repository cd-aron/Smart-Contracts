//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract multisig{ 
    address private institute;
    address private  student;
    string private data;
    bool private verifiedByInstitute;
    bool private verifiedByStudent;

    modifier onlyInstitute(){
        require(msg.sender == institute, "Only Institute can call this function");
        _;
    }

    modifier onlyStudent(){
        require(msg.sender == student, "Only Student can call this function");
        _;
    }

    modifier onlyInstituteOronlyStudent(){
        require(msg.sender == institute || msg.sender == student, "Only Institue & Student can access");
        _;
    }

    constructor(address _institute){
        institute = _institute;
    }

    function sendToVerify(address _student, string memory _data) external onlyInstitute {
         student = _student;
         data = _data;
         verifiedByStudent = false;
         verifiedByInstitute = false;
    }

    function getDetails() external view onlyInstituteOronlyStudent returns(address _institute, address _student, string memory _data, bool _verifiedByStudent, bool _verifiedByInstitute) {
        _institute = institute;
        _student = student; 
        _data = data;
        _verifiedByStudent = verifiedByStudent;
        _verifiedByInstitute = verifiedByInstitute;
    }

    function studentVerify() external onlyStudent{
        require(!verifiedByStudent, "Data already verified by student");
          verifiedByStudent = true;
    }

    function instituteVerify () external onlyInstitute{
        require(verifiedByStudent, "Data must be verified by student");
        require(!verifiedByInstitute, "Data already verified by institute");
          verifiedByInstitute = true;
    }
}
