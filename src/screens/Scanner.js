import React, { Component } from "react";
import { StyleSheet, Text, TouchableOpacity, Linking } from "react-native";
import QRCodeScanner from "react-native-qrcode-scanner";
import axios from "axios";

class Scanner extends Component {
  onSuccess(e) {
    const { badge } = this.props;
    const URL = Config.API_URL + Config.API_BADGES + badge;

    axios
      .get(URL)
      .then(res => {
        Alert.alert("Badge redeem", "Success!", { cancelable: false });
      })
      .catch(err => {
        Alert.alert("Badge redeem", "Error!" + { err }, { cancelable: false });
      });
  }

  render() {
    return (
      <QRCodeScanner
        onRead={this.onSuccess.bind(this)}
        reactivate={true}
        topContent={
          <Text style={styles.centerText}>
            Badge:
            <Text style={styles.textBold}>{this.props.badge}</Text>
          </Text>
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
