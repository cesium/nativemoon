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
      count: 0,
      last: ""
    };
  }

  validateJson = json => {
    const { count } = this.state;
    const { badgeName } = this.props;

    if (json.data.hasOwnProperty("redeem")) {
      this.setState({ message: badgeName, count: count + 1 });
    } else {
      this.setState({ message: "Redeem error" });
    }
  };

  onBarRead = e => {
    const { badge } = this.props;
    const URL = Config.API_URL + Config.API_REDEEM;

    var regex = /.*https:\/\/intra.seium.org\/user\/(([A-Za-z0-9]+-*)+)/;
    const result = regex.exec(e.data);

    var id;
    if (result != null && result.length >= 2) id = result[1];
    else id = e.data;

    if (id != null && id !== this.state.last) {
      var headers = {
        Authorization: "Bearer " + this.props.jwt
      };

      axios
        .post(
          URL,
          {
            redeem: {
              attendee_id: id,
              badge_id: badge
            }
          },
          { headers: headers }
        )
        .then(res => {
          this.validateJson(res);
        })
        .catch(() => {
          this.setState({ message: "Redeem error" });
        });
      this.setState({ last: id });
    } else {
      this.setState({ message: "Not a valid qr code" });
    }
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
        bottomContent={
          <TouchableOpacity style={styles.buttonTouchable}>
            <Text style={styles.buttonText}>{this.state.count}</Text>
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
