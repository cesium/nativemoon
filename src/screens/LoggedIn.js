import React, {Component} from 'react';
import {Button, Text, View} from "react-native";

export default class LoggedIn extends Component {
    constructor(props) {
        super(props);
    }

    render() {
        return (
            <View>
                <Text>
                    SEIUM
                </Text>
                <Button
                    onPress={this.props.deleteJWT}
                    title="Log Out"
                />
            </View>

        );
    };
}

