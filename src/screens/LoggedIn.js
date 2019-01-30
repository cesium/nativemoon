import React, { Component } from "react";
import { Button, Text, View, FlatList } from "react-native";
import Config from "react-native-config";
import Scanner from "./Scanner";
import axios from "axios";

class LoggedIn extends Component {
  constructor(props) {
    super(props);
    this.state = {
      qr: false,
      badges: [],
      badge: "",
      badgeId: -1,
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
      const badges = this.filterByDate(json.data.data);
      this.setState({ badges: badges });
    } else {
      this.setState({ error: json.data.error });
    }
  }

  filterByDate(badges) {
    return badges.filter(b => this.betweenDates(b.begin, b.end));
  }

  betweenDates(dateBadgeB, dateBadgeE) {
    const dbb = new Date(dateBadgeB);
    const dbe = new Date(dateBadgeE);
    const ds = new Date();

    return ds >= dbb && ds <= dbe;
  }

  render() {
    if (this.state.qr) {
      return (
        <Scanner
          badge={this.state.badgeId}
          badgeName={this.props.badge}
          deleteJWT={this.props.deleteJWT}
          jwt={this.props.jwt}
        />
      );
    } else {
      const { error, badge } = this.state;
      const { errorTextStyle, badgeStyle, logoutButton } = styles;

      return (
        <View>
          <FlatList
            data={this.state.badges}
            ItemSeparatorComponent={this.listSeparator}
            renderItem={({ item }) => (
              <View>
                <Text onPress={this.selectItem.bind(this, item)}>
                  {item.name}
                </Text>
              </View>
            )}
            keyExtractor={(item, index) => index.toString()}
          />
          <Text style={errorTextStyle}>{error}</Text>
          {badge != "" && (
            <View>
              <Button
                style={badgeStyle}
                onPress={() => this.setState({ qr: !this.state.qr })}
                title={"Scanner (" + badge + ")"}
              />
            </View>
          )}
          <Button
            style={logoutButton}
            onPress={this.props.deleteJWT}
            color="#FF0000"
            title="Log Out"
          />
        </View>
      );
    }
  }

  listSeparator = () => {
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
    this.setState({ badge: badge.name, badgeId: badge.id });
  }
}

const styles = {
  errorTextStyle: {
    alignSelf: "center",
    borderBottomWidth: 1,
    fontSize: 18,
    color: "red"
  },
  badgeStyle: {},
  logoutButton: {
    flex: 1,
    justifyContent: "flex-end",
    marginBottom: 20
  }
};

export default LoggedIn;
