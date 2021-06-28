import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:obi_mobile/configs/config.dart' as config;

class SocketIo{
  IO.Socket socket;
  final String apiUrl = config.API_URL;
  final String url = 'http://'+ config.API_URL;

  IO.Socket connect() {
    if (this.socket == null) {
      this.socket = IO.io(url,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build());
      this.socket.connect();
      
      this.socket.onConnect((_) {
        print('Socket Connected');
      });
      this.socket.onConnectError((data) => print('Error: '+data.toString()));

      return this.socket;
    }
    else {
      return this.socket;
    }
  }
}