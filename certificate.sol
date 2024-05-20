    // SPDX-License-Identifier: MIT
    pragma solidity ^0.8.0;

    import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
    import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

    contract certificate is ERC721URIStorage {
        
        uint256 public newTokenId;
        address public institute;
        address public student;
        
        struct certificateMetaData{
            address studentAddress;
            string certificateNo;
            string registerNo;
            string dateOfIssue;
            string studentName;
            string cgpa;
            bool isCertificateVerifiedByInstitute;
            bool isCertificateVerifiedByStudent;
        }

        mapping (address => certificateMetaData) public studentCertificate;
        mapping (address => bool) public isCertificateAlreadyExists;
        mapping (address => bool) public isCertificateIssued;


        modifier onlyInstitute() {
            require(msg.sender == institute, "Only Institute can access ");
            _;
        }

        constructor(address _institute) ERC721 ("Diploma Certificate", "CCCT"){
            institute = _institute;
        }

        function storeCertificateMetaData (address _studentAddress, string memory _certificateNo, string memory _registerNo, string memory _dateOfIssue, string memory _studentName, string memory _cgpa) public onlyInstitute{
            require(!isCertificateAlreadyExists[_studentAddress], "Certificate Already Exists");
            studentCertificate[_studentAddress] = certificateMetaData(
                _studentAddress,
                _certificateNo,
                _registerNo,
                _dateOfIssue,
                _studentName,
                _cgpa,
                false,
                false
            );

            isCertificateAlreadyExists[_studentAddress] = true;
            
        }

        function verifyByInstitute(address _studentAddress) public onlyInstitute returns(bool){
          require(isCertificateAlreadyExists[_studentAddress], "Student Certificate Doesn't Exists");
          certificateMetaData storage Certificate = studentCertificate[_studentAddress];
          Certificate.isCertificateVerifiedByInstitute = true;
          return true;
        }

        function verifyByStudent() public returns (bool) {
          require(isCertificateAlreadyExists[msg.sender], "Student Certificate Doesn't Exists");
          certificateMetaData storage Certificate = studentCertificate[msg.sender];
          require(Certificate.isCertificateVerifiedByInstitute == true, "Certificate isn't verified by Instiute");
          Certificate.isCertificateVerifiedByStudent = true;
          return true;
        }

        function getCertificateVerificationStatus(address _studentAddress) public view returns(bool){
          certificateMetaData storage Certificate = studentCertificate[_studentAddress];
          require(Certificate.isCertificateVerifiedByInstitute == true && Certificate.isCertificateVerifiedByStudent == true, 
          "Student certificate is not being verified by Institue or Student");
          return true;
        }

        function createCertificateNFT(address _studentAddress) public onlyInstitute returns (uint256) {
  
          require(getCertificateVerificationStatus(_studentAddress) == true, "Student Certificate not Verified");
          require(isCertificateIssued[_studentAddress] == false, "Student Certificate Already Exists");
          _mint(_studentAddress, newTokenId);
          isCertificateIssued[_studentAddress] = true;
          return newTokenId;
        }


        function verifyCertificate(address _studentAddress) 
        public 
        view 
        returns (
            address studentAddress,
            string memory certificateNo,
            string memory registerNo,
            string memory dateOfIssue,
            string memory studentName,
            string memory cgpa,
            bool isCertificateVerifiedByInstitute,
            bool isCertificateVerifiedByStudent
        ) 
    {
        require(isCertificateAlreadyExists[_studentAddress], "Student Certificate Doesn't Exist");
        certificateMetaData storage Certificate = studentCertificate[_studentAddress];
        require(isCertificateIssued[_studentAddress], "Certificate NFT not issued");

        return (
            Certificate.studentAddress,
            Certificate.certificateNo,
            Certificate.registerNo,
            Certificate.dateOfIssue,
            Certificate.studentName,
            Certificate.cgpa,
            Certificate.isCertificateVerifiedByInstitute,
            Certificate.isCertificateVerifiedByStudent
        );
    }


    }