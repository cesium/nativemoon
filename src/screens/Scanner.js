import React, { Component } from "react";
import {
  StyleSheet,
  Text,
  View,
} from "react-native";
import { RNCamera } from "react-native-camera";
import axios from "axios";

class Scanner extends Component {
  constructor(props) {
    super(props);
    this.state = {
      qrcode: "",
      count: 0
    };
  }

  validateJson = json => {
    const { count } = this.state;
    const { badgeName } = this.props;

    if (json.data.hasOwnProperty("redeem")) {
        this.setState({ qrcode: badgeName});
        this.setState({ count: count + 1});
    } else {
      this.setState({ qrcode: "Redeem error" });
    }
  }

  onBarRead = e => {
    const { badge } = this.props;
    const URL = Config.API_URL + Config.API_REDEEM;

    axios
      .post(URL, {
        redeem: {
          attendee_id: e.data,
          badge_id: badge
        }
      })
      .then(res => {
        this.validateJson(res);
      })
      .catch(() => {
        this.setState({ qrcode: "Redeem error" });
      });
  };

  render() {
    return (
      <View style={styles.container}>
        <RNCamera
          barCodeTypes={[RNCamera.Constants.BarCodeType.qr]}
          flashMode={RNCamera.Constants.FlashMode.on}
          style={styles.preview}
          onBarCodeRead={this.onBarRead}
          ref={cam => (this.camera = cam)}
        >
          <Text
            style={{
              backgroundColor: "white"
            }}
          >
            [{this.state.count}] {this.state.qrcode}
          </Text>
        </RNCamera>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    flexDirection: "row"
  },
  preview: {
    flex: 1,
    justifyContent: "flex-end",
    alignItems: "center"
  }
});

export default Scanner;