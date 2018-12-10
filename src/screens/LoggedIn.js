import React, { Component } from "react";
import { Button, Text, View, FlatList, TouchableHighlight } from "react-native";
import Config from "react-native-config";
import axios from "axios";

export default class LoggedIn extends Component {
  constructor(props) {
    super(props);
    this.state = {
      badges: [],
      badge: "",
      loading: false,
      error: ""
    };
    this.validateJson = this.validateJson.bind(this);
  }

  componentDidMount() {
    const URL = Config.API_URL + Config.API_BADGES;
    this.setState({ error: "", loading: true });
    axios
      .get(URL, {
        headers: {
          Authorization: "Bearer " + this.props.jwt
        }
      })
      .then(res => {
        this.validateJson(res);
      })
      .catch(e => {
        this.setState({
          loading: false,
          error: "Error loading badges"
        });
      });
  }

  validateJson(json) {
    if (json.hasOwnProperty("data")) {
      const badges = json.data.data;
      //const badges = this.filterByDate(json.data);
      this.setState({ badges: badges });
    } else {
      this.setState({ error: json.data.error });
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

  componentWillUnmount() {
    console.log(this.state);
  }
  render() {
    const { error } = this.state;
    const { errorTextStyle } = styles;

    return (
      <View>
        <Text>BADGES</Text>
        <FlatList
          data={this.state.badges}
          ItemSeparatorComponent={this.FlatListItemSeparator}
          renderItem={({ item }) => (
            <TouchableHighlight
              style={{
                backgroundColor: "red",
                height: 60,
                flexDirection: "row"
              }}
            >
              <Text onPress={this.selectItem.bind(this, item.name)}>
                {item.description}
              </Text>
            </TouchableHighlight>
          )}
          keyExtractor={(item, index) => index.toString()}
        />

        <Text style={errorTextStyle}>{error}</Text>
        <Button onPress={this.props.deleteJWT} title="Log Out" />
      </View>
    );
  }

  FlatListItemSeparator = () => {
    return (
      <View
        style={{
          height: 1,
          width: "100%",
          backgroundColor: "#607D8B"
        }}
      />
    );
  };

  selectItem(badge) {
    this.setState({ badge: badge });
  }
}

const styles = {
  errorTextStyle: {
    alignSelf: "center",
    borderBottomWidth: 1,
    fontSize: 18,
    color: "red"
  }
};
