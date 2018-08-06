import React, {Component} from 'react';
import Login from './components/Login';
import LoggedIn from './screens/LoggedIn';
import deviceStorage from './services/deviceStorage';

export default class App extends Component {
    constructor() {
        super();
        this.state = {
            jwt: ''
        };
        this.newJWT = this.newJWT.bind(this);
        this.deleteJWT = deviceStorage.deleteJWT.bind(this);
        this.loadJWT = deviceStorage.loadJWT.bind(this);
        this.loadJWT();
    }

    newJWT(jwt) {
        this.setState({
            jwt: jwt
        });
    }

    render() {
        if (!this.state.jwt) {
            return (
                <Login putJWT={this.newJWT}/>
            );
        } else {
            return (
                <LoggedIn/>
            );
        }
    }
}
