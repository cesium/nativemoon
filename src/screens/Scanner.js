import React, { Component } from "react";
import { StyleSheet, Text, TouchableOpacity } from "react-native";
import QRCodeScanner from "react-native-qrcode-scanner";
import Config from "react-native-config";
import axios from "axios";

class Scanner extends Component {
  constructor(props) {
    super(props);
    this.state = {
      message: "",
      count: 0
    };
  }

  validateJson = json => {
    const { count } = this.state;
    const { badgeName } = this.props;

    if (json.data.hasOwnProperty("redeem")) {
      this.setState({ message: badgeName });
      this.setState({ count: count + 1 });
    } else {
      this.setState({ message: "Redeem error" });
    }
  };

  onBarRead = e => {
    const { badge } = this.props;
    const URL = Config.API_URL + Config.API_REDEEM;
    const id = stripUrl(e.data);
    axios
      .post(URL, {
        redeem: {
          attendee_id: id,
          badge_id: badge
        }
      })
      .then(res => {
        this.validateJson(res);
      })
      .catch(() => {
        this.setState({ message: "Redeem error" });
      });
  };

  stripUrl = str => {
    const baseUrl = "https://intra.seium.org/user/";
    return str.substr(baseUrl.length, str.length);
  };

  render() {
    return (
      <QRCodeScanner
        checkAndroid6Permissions={true}
        onRead={this.onBarRead}
        reactivate={true}
        topContent={
          <TouchableOpacity style={styles.buttonTouchable}>
            <Text style={styles.buttonText}>{this.state.message}</Text>
          </TouchableOpacity>
        }
        bottomContent={
          <TouchableOpacity style={styles.buttonTouchable}>
            <Text style={styles.buttonText}>Redeemed: {this.state.count}</Text>
          </TouchableOpacity>
        }
      />
    );
  }
}

const styles = StyleSheet.create({
  centerText: {
    flex: 1,
    fontSize: 18,
    padding: 32,
    color: "#777"
  },
  textBold: {
    fontWeight: "500",
    color: "#000"
  },
  buttonText: {
    fontSize: 21,
    color: "rgb(0,122,255)"
  },
  buttonTouchable: {
    padding: 16
  }
});

export default Scanner;
