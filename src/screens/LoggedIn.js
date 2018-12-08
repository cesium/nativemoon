import React, { Component } from "react";
import { Button, Text, View } from "react-native";
import deviceStorage from "../services/deviceStorage";

export default class LoggedIn extends Component {
  constructor(props) {
    super(props);
    this.state = {
      badges: [],
      loading: false
    };
  }

  getBadges() {
    const URL = Config.API_URL + Config.API_BADGES;
    this.setState({ error: "", loading: true });
    const jwt = deviceStorage.loadJWT();
    axios
      .post(URL, {
        headers: {
          Authorization: "Bearer " + jwt
        }
      })
      .then(res => {
        this.validateJson(res);
      })
      .catch(() => {
        this.setState({ loading: false, error: "Error loading badges" });
      });
  }

  validateJson(json) {
    if (json.hasOwnProperty("data")) {
      const badges = this.filterByDate(json.data);
      this.setState({ badges: badges });
    } else {
      this.setState({ error: json.data.error, loading: false });
    }
  }

  filterByDate(badges) {
    return badges.filter(b => this.betweenDates(b.begin, b.end));
  }

  betweenDates(dateBadgeB, dateBadgeE) {
    let dbb = new Date(dateBadgeB).getDate();
    let dbe = new Date(dateBadgeE).getDate();
    let ds = new Date().getDate();

    return ds >= dbb && ds <= dbe;
  }

  render() {
    return (
      <View>
        <Text>SEIUM</Text>
        <Text>{this.state.badges}</Text>
        <Button onPress={this.props.deleteJWT} title="Log Out" />
      </View>
    );
  }
}
