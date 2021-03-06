/* eslint-disable jsx-a11y/accessible-emoji */

import { SyncOutlined } from "@ant-design/icons";
import { formatEther, parseEther } from "@ethersproject/units";
import { Card, Button, Modal, DatePicker, Divider, Input, Popconfirm, Progress, Slider, Spin, Switch, AutoComplete, Space, Select, Radio, Form, Menu, Dropdown, Upload } from "antd";
import { EyeInvisibleOutlined, EyeTwoTone, UserOutlined, DownOutlined, UploadOutlined, InboxOutlined } from '@ant-design/icons';
import React, { useState, useEffect } from "react";
import {Ipfs, Slate} from "../helpers"
import AnchorService from "../anchorServices/anchor.service";
import { Document, Page } from "react-pdf";
import aggrementPdf from "./PaymentAggrement.pdf";

import { STORAGE, STORAGE_URL } from "../constants";



export default function SupplierUI({
  name,
  address,
  tx,
  provider,
  chainId,
  writeContracts,
  readContracts,
  cashflowContract,
  setCashflowEvents,
  MultisigWalletContract,
  useContractLoader,
  customContract,
  setMultisigWalletContract
}) {

  let contracts;



  const [anchorList, setAnchorList] = useState("Select Anchor from the list");
  const [paymentDateStr, setPaymentDateStr] = useState("");
  const [paymentDate, setPaymentDate] = useState(0);
  const [anchor, setAnchor] = useState("Select Anchor from the list");
  const [invoiceAmt, setInvoiceAmt] = useState("");
  const [ethPrice, setEthPrice] = useState("");
  const [ipfsHash, setIpfsHash] = useState("");
  const [buffer, setBuffer] = useState();
  const [visible, setVisible] = useState(false);
  const [numPages, setNumPages] = useState(null);
  const [walletDesc, setWalletDesc] = useState("");
  const [walletFrom, setWalletFrom] = useState("");
  const [walletTo, setWalletTo] = useState("");

  const [anchors, setAnchors] = useState([]);

  useEffect( async () => {
  AnchorService.getAnchorList().then( res => {
    console.log("AnchorService.getAnchorList ", res);
    setAnchors(res.data)
    setAnchorList(res.data)
  })
}, [])

const submitOnConfirmation = async () => {

  console.log("anchor ", anchor);

  const anchorS = anchorList && anchorList.find(item => item.value === anchor);
  const selectedAnchor = anchorS && anchorS.key;

  console.log(" supplier contract values  ", address, paymentDate, selectedAnchor, parseEther("" +invoiceAmt), ipfsHash, writeContracts);
  console.log("***selectedAnchor", selectedAnchor);
  console.log("MultiSigWallet ", writeContracts.MultiSigWallet);

  // let supplier = await tx(writeContracts.MultiSigWallet.suppliers(0));
  // console.log(" supplier ", supplier);

  // const supplier = await writeContracts.MultiSigWallet.suppliers(0);
  // if(!supplier) {
  //   console.log(" Adding supplier");
  //   supplier = await tx(writeContracts.MultiSigWallet.addSupplier(address));
  //   const checkSupplier = await tx(writeContracts.MultiSigWallet.suppliers());
  //   console.log(" added supplier ", supplier, checkSupplier);
  //   console.log(" added supplier ", supplier);
  // }
  // if(supplier){
    console.log(writeContracts);
    const transId = await tx(writeContracts.MultiSigWallet.submitTransaction(ipfsHash, ipfsHash, selectedAnchor, parseEther("" +invoiceAmt), paymentDate));
    console.log("transId", transId);
    // const newTrx = await tx(readContracts.MultiSigWallet.getConfirmationCount(transId.hash));
    // console.log(" newTrx ", newTrx);
  // }

}

const anchorMenus = (
    <Menu onClick={e => {
      // console.log(" in anchorMenu", e);
      const newSelected = anchors && anchors.find(item => item.key === e.key);
      console.log("newSelected", newSelected && newSelected.key);
      setAnchor(newSelected && newSelected.value);
    }}>
      {anchors && anchors.map(item => (
        <Menu.Item key={item.key}  icon={<UserOutlined />}>{item.value}</Menu.Item>
      ))}
    </Menu>
  );
  return (
    <div>
      {/*
        ?????? Here is an example UI that displays and sets the purpose in your smart contract:
      */}
      <div  style={{ border: "1px solid #cccccc", padding: 16, width: 1000, margin: "auto", marginTop: 64, padding: 60 }}>
        <h1> Supplier Details</h1>
        <Divider />
        <div align="left" style={{ margin: 8 }}>
        <Dropdown overlay={anchorMenus}>
          <Button>
            {anchor} <DownOutlined />
          </Button>
        </Dropdown>
        <div style={{ margin: '24px 0' }} />
        <div >
        <DatePicker
          placeholder="Payment date"
          onChange={ (date, dateString) => {
            console.log(date, dateString, date.valueOf());
            setPaymentDate(date.valueOf());
            setPaymentDateStr(dateString);
          }}
         />
        </div>

        <div style={{ margin: '24px 0'}} />
        {/* { if(ipfsHash) { */}
            <img src={STORAGE_URL+`${ipfsHash}`} alt="" align="middle"/>
          {/* }
        } */}
        <Upload.Dragger name="files" action="/upload.do"
          onChange={ async (e) => {
            // e.preventDefault()
            console.log(" upload event ", e);
            const file = e.fileList[0] && e.fileList[0].originFileObj;
            const reader = new window.FileReader()
            reader.readAsArrayBuffer(file)
            reader.onloadend = async () => {
              const buff = Buffer(reader.result);
              setBuffer(buff);
              console.log('buffer', buff);
              if(STORAGE==="IPFS"){
                Ipfs.files.add(buff, (error, result) => {
                  if(error) {
                    console.error(error)
                    return
                  }
                  console.log(" ipfs Hash ", result[0] && result[0].hash);
                  setIpfsHash(result[0] && result[0].hash);
                })
              } else if (STORAGE=="FILECOIN"){
                const response = await Slate(file)
                if(response.decorator!=="V1_UPLOAD_TO_SLATE"){
                  console.log("ERROR IN UPLOAD",response);
                } else {
                  setIpfsHash(response && response.data.cid);
                  console.log("UPLOAD DONE:    ", response)
                }
                
              }
            }
        }}
        >
        <p className="ant-upload-drag-icon">
            <InboxOutlined />
        </p>
        <p className="ant-upload-text">Invoice Upload</p>
        <p className="ant-upload-hint">Click or drag file to this area to upload the Invoice</p>
        <p className="ant-upload-hint">Support for a single or bulk upload.</p>
        </Upload.Dragger>


        <div style={{ margin: '24px 0' }} />

          <Input addonBefore="$"
            placeholder="Invoice Amount"
            autoComplete="off"
            onChange={e => {
              setInvoiceAmt(e.target.value);
            }}
          />
        {/* </Input.Group> */}
        </div>
        <Divider />
        <Button  type="primary"
            onClick={async () => {
              const price = await tx(readContracts.PriceConsumerV3.ethPrice());
              setEthPrice(price);
              setVisible(true);
            }}
          >
            Submit
          </Button>
          <Modal
              title="Payment Aggrement"
              centered
              visible={visible}
              onOk={() => { setVisible(false)
                          submitOnConfirmation();
                      }}
              onCancel={() => setVisible(false)}
              okText="I Agree"
              // cancelText="Ciao"
              width={1000}>
            <Document
              file={aggrementPdf}
              options={{ workerSrc: "/pdf.worker.js" }}
              onLoadSuccess={({ numPages })=>setNumPages(numPages)}>

              {Array.from(new Array(numPages), (el, index) => (
                <Page key={`page_${index + 1}`} pageNumber={index + 1} />
              ))}
            </Document>

            <Card title="Invoice Amount" bordered={false} style={{ width: 300 }}>
              <p>$ {invoiceAmt}</p>
              <p>ETH {invoiceAmt/ethPrice}</p>

            </Card>
          </Modal>
        <Divider />
{/* 
        <Input addonBefore=""
            placeholder="Wallet Description"
            autoComplete="off"
            onChange={e => {
              setWalletDesc(e.target && e.target.value);
            }}
          />

        <Button
            onClick={async () => {
              const result = await AnchorService.createtWalletAPI(walletDesc);
              console.log(" created wallet ",result);

            }}
          > */}
            {/* Create Wallet
          </Button>
          <Input addonBefore=""
            placeholder="Wallet from"
            autoComplete="off"
            onChange={e => {
              setWalletFrom(e.target && e.target.value);
            }}
          />
        <Input addonBefore=""
            placeholder="Wallet to"
            autoComplete="off"
            onChange={e => {
              setWalletTo(e.target && e.target.value);
            }}
          />
          <Button
            onClick={async () => {
              const result = await AnchorService.transferAPI(walletFrom, walletTo, 1);
              console.log(" created wallet ",result);

            }}
          >
            Transfer Wallet
          </Button> */}
        </div>
    </div>
  );
}