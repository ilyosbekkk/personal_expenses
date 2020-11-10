import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Test extends StatefulWidget {
 final payment_option;
 final mid;
 final oid;
 final goods;
 final amt;
 final name;
 final hpp_method;
 final mName;
 final phoneNumber;
 final email;
 final offering_period;
 final charset;
 final tax;
 final tax_free;
 final quoate_base;
 final card_option;
 final card_code;
 final bank_dt;
 final bank_tm;
 final reserved;

  const Test( this.payment_option, this.mid, this.oid, this.goods, this.amt, this.name, this.hpp_method, this.mName, this.phoneNumber, this.email, this.offering_period, this.charset, this.tax, this.tax_free, this.quoate_base, this.card_option, this.card_code, this.bank_dt, this.bank_tm, this.reserved);
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl:
      'https://mobile.inicis.com/smart/payment/?P_INI_PAYMENT=${widget.payment_option}&P_MID=${widget.mid}&P_OID=${widget.oid}&P_GOODS=${widget.goods}&P_AMT=${widget.amt}&P_UNAME=${widget.name}&P_HPP_METHOD=${widget.hpp_method}&P_MNAME=${widget.mName}&P_MOBILE=${widget.phoneNumber}&P_EMAIL=${widget.email}&P_OFFER_PERIOD=${widget.offering_period}&P_CHARSET=${widget.charset}&P_TAX=${widget.tax}&P_TAXFREE=${widget.tax_free}&P_QUOTABASE=${widget.quoate_base}&P_CARD_OPTION=${widget.card_option}&P_ONLY_CARDCODE=${widget.card_code}&P_VBANK_DT=${widget.bank_dt}&P_VBANK_TM=${widget.bank_tm}&P_RESERVED=${widget.reserved}',
      javascriptMode: JavascriptMode.unrestricted,
    );
  }


}
