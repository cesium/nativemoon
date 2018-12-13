import React, { Component } from "react";
import Login from "./components/Login";
import { Loading } from "./components/common/";
import LoggedIn from "./screens/LoggedIn";
import deviceStorage from "./services/deviceStorage";

export default class App extends Component {
  constructor() {
    super();
    this.state = {
      jwt: "",
      loading: true
    };
    this.newJWT = this.newJWT.bind(this);
    this.deleteJWT = deviceStorage.deleteJWT.bind(this);
    this.loadJWT = deviceStorage.loadJWT.bind(this);
  }

  componentWillMount() {
    this.loadJWT();
  }

  newJWT(jwt) {
    this.setState({
      jwt: jwt
    });
  }

  render() {
    if (this.state.loading) {
      return <Loading size={"large"} />;
    } else if (!this.state.jwt) {
      return <Login newJWT={this.newJWT} />;
    } else if (this.state.jwt)
      return <LoggedIn jwt={this.state.jwt} deleteJWT={this.deleteJWT} />;
  }
}
