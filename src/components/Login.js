import React, {Component, Fragment} from 'react';
import {View, Text, Button} from 'react-native';
import {Input, Loading} from './common';
import deviceStorage from '../services/deviceStorage';
import axios from 'axios';

export default class Login extends Component {
    constructor(props) {
        super(props);
        this.state = {
            email: '',
            password: '',
            error: '',
            loading: false
        };
        this.validateJson = this.validateJson.bind(this);
        this.loginUser = this.loginUser.bind(this);
    }

    validateJson(json) {
        if (json.data.hasOwnProperty('jwt')) {
            deviceStorage.saveJWT("id_token", json.data.jwt);
            this.props.newJWT(json.data.jwt);
        }
        else {
            this.setState({error: json.data.error, loading: false});
            console.log(json);
        }
    }

    loginUser() {
        const API_CALL = 'https://sei19-safira.herokuapp.com/api/auth/sign_in';
        const {email, password} = this.state;
        this.setState({error: '', loading: true});

        axios.post(API_CALL, {
            email: email,
            password: password
        })
            .then(res => {
                this.validateJson(res);
            })
            .catch(() => {
                this.setState({loading: false, error: "Login error"});
            });
    }

    render() {
        const {email, password, error, loading} = this.state;
        const {form, section, errorTextStyle} = styles;

        return (
            <Fragment>
                <View style={form}>
                    <View style={section}>
                        <Input
                            placeholder='patron@cesium.pt'
                            label="Email"
                            value={email}
                            onChangeText={email => this.setState({email})}
                        />
                    </View>

                    <View style={section}>
                        <Input
                            secureTextEntry
                            placeholder="password"
                            label="Password"
                            value={password}
                            onChangeText={password => this.setState({password})}
                        />
                    </View>

                    {!loading ?
                        <Button
                            onPress={this.loginUser}
                            title="Login"
                        />
                        :
                        <Loading size={'large'}/>
                    }



                    <Text style={errorTextStyle}>
                        {error}
                    </Text>

                </View>
            </Fragment>
        );
    }
}

const styles = {
    form: {
        width: '100%',
        borderTopWidth: 1,
        borderColor: '#ddd',
    },
    section: {
        flexDirection: 'row',
        borderBottomWidth: 1,
        backgroundColor: '#fff',
        borderColor: '#ddd',
    },
    errorTextStyle: {
        alignSelf: 'center',
        borderBottomWidth: 1,
        fontSize: 18,
        color: 'red'
    }
};