import { AsyncStorage } from "react-native";

const deviceStorage = {
  async saveJWT(key, token) {
    try {
      await AsyncStorage.setItem(key, token);
    } catch (error) {
      console.log("AsyncStorage Error: " + error.message);
    }
  },

  async loadJWT() {
    try {
      const value = await AsyncStorage.getItem("id_token");
      if (value !== null) {
        this.setState({
          jwt: value,
          loading: false
        });
      } else {
        this.setState({
          loading: false
        });
      }
    } catch (error) {
      console.log("AsyncStorage Error: " + error.message);
    }
  },

  async deleteJWT() {
    try {
      await AsyncStorage.removeItem("id_token").then(() => {
        this.setState({
          jwt: ""
        });
      });
    } catch (error) {
      console.log("AsyncStorage Error: " + error.message);
    }
  }
};

export default deviceStorage;
