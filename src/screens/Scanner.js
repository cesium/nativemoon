import React, { Component } from "react";
import { StyleSheet, Text, TouchableOpacity } from "react-native";
import QRCodeScanner from "react-native-qrcode-scanner";
import axios from "axios";

class Scanner extends Component {
  constructor(props) {
    super(props);
    this.state = {
      count: 0
    };
  }

  onSuccess(e) {
    const { count } = this.state;
    const { badge } = this.props;
    const URL = Config.API_URL + Config.API_BADGES + badge;
    
    axios
      .get(URL)
      .then(() => {
        this.setState({count: count + 1});
      })
      .catch(() => {
      });
  }

  render() {
    return (
      <QRCodeScanner
        checkAndroid6Permissions={true}
        onRead={this.onSuccess.bind(this)}
        reactivate={true}
        topContent={
          <Text style={styles.centerText}>
            Badge:
            <Text style={styles.textBold}>{this.props.badge}</Text>
          </Text>
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
