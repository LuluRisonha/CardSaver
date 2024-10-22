import 'dart:io';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:scanner_overlay/scanner_overlay.dart';
import 'package:audioplayers/audioplayers.dart'; // Importar o pacote audioplayers

class CameraPage extends StatefulWidget 
{
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  bool _isPictureTaken = false;
  XFile? _pictureFile;

  // Lista para armazenar as cartas reconhecidas
  List<Map<String, dynamic>> recognizedCards = [];

  // Criar uma instância do Audioplayer para tocar o som
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() 
  {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras(); // Obtém todas as câmeras disponíveis

    if (_cameras != null && _cameras!.isNotEmpty) {
      _controller = CameraController(
        _cameras![0], // Usa a primeira câmera disponível (geralmente a traseira)
        ResolutionPreset.high, // Define a resolução da câmera
      );

      await _controller!.initialize(); // Inicializa a câmera

      if (!mounted) return;

      setState(() {
        _isCameraInitialized = true;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose(); // Libera o controlador da câmera ao sair
    _audioPlayer.dispose(); // Libera o recurso de áudio ao sair
    super.dispose();
  }

  // Função de reconhecimento da carta
 Future<String> recognizeCard(XFile picture) async {
  // Crie uma instância do TextRecognizer
  final textRecognizer = TextRecognizer(
    script: TextRecognitionScript.latin,
  );

  // Converta o XFile (imagem capturada) em um File
  final File imageFile = File(picture.path);

  // Crie um InputImage a partir do arquivo da imagem
  final InputImage inputImage = InputImage.fromFile(imageFile);

  // Agora você pode processar a imagem usando o recognizer
  final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

  // Itere sobre os blocos de texto reconhecidos e retorne o texto encontrado
  String result = '';

  for (TextBlock block in recognizedText.blocks) {
    for (TextLine line in block.lines) {
      result += line.text + '\n';  // Concatenar o texto reconhecido
    }
  }

  // Após processar, libere os recursos do recognizer
  textRecognizer.close();

  // Retorne o texto reconhecido (ou uma string vazia se nada foi reconhecido)
  return result.isNotEmpty ? result : 'Nenhum texto encontrado';
} 

  // Função para buscar a carta no Firestore
  Future<void> fetchCardFromFirestore(String cardName) async {
    // Busca a carta no Firestore com base no nome reconhecido
    var snapshot = await FirebaseFirestore.instance
        .collection('cards')
        .where('name', isEqualTo: cardName)
        .get();

    if (snapshot.docs.isNotEmpty) {
      var cardData = snapshot.docs.first.data();
      setState(() {
        recognizedCards.add(cardData);  // Adiciona a carta reconhecida à lista
      });
    } else {
      print('Carta não encontrada no Firestore.');
    }
  }

  // Função para reproduzir o som de captura
  Future<void> playCaptureSound() async {
    await _audioPlayer.play(AssetSource('sounds/Scan_bip.mp3'));
  }

  Future<void> _takePicture() async {
    if (_controller != null && _controller!.value.isInitialized) {
      if (!_controller!.value.isTakingPicture) {
        try {
          _pictureFile = await _controller!.takePicture();
          setState(() {
            _isPictureTaken = true; // Indica que a foto foi tirada
          });

          // Reproduz o som de captura da câmera
          await playCaptureSound();

          // Simula o reconhecimento da carta escaneada
          String recognizedCardName = await recognizeCard(_pictureFile!);

          // Busca a carta no Firestore e atualiza a prévia
          await fetchCardFromFirestore(recognizedCardName);

        } catch (e) {
          print('Erro ao tirar foto: $e');
        }
      }
    }
  }

    void signOut(context) {
    Navigator.pushReplacementNamed(context, '/login');
  }

  void SendDeck(context) {
    Navigator.pushReplacementNamed(context, '/deck');
  }

  void SendListar(context) {
    Navigator.pushReplacementNamed(context, '/listar');
  }

  void SendAjuda(context) {
    Navigator.pushReplacementNamed(context, '/ajuda');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 181, 190, 195),
      appBar: AppBar(title: Text(''), actions: []),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 195, 201, 206),
              ),
              child: Text(
                'Preferências',
                style: TextStyle(
                  color: (Colors.black),
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
                leading: Icon(Icons.home),
                title: Text('Deck'),
                onTap: () {
                  Navigator.pushNamed(context, '/deck');
                }),
            ListTile(
                leading: Icon(Icons.person),
                title: Text('Listar cartas'),
                onTap: () {
                  Navigator.pushNamed(context, '/listar');
                }),
            ListTile(
                leading: Icon(Icons.settings),
                title: Text('Ajuda'),
                onTap: () {
                  Navigator.pushNamed(context, '/ajuda');
                }),
            const Divider(),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.sunny),
            ),
            const IconButton(
              onPressed: null,
              icon: Icon(Icons.dark_mode),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Sair'),
              onTap: () => signOut(context),
            ),
          ],
        ),
      ),
      body: _isCameraInitialized
          ? Stack(
              children: <Widget>[
                // Exibe a pré-visualização da câmera
                CameraPreview(_controller!),

                // Scanner overlay para guiar o usuário
                Center(
                  child: ScannerOverlay(
                    height: 400,
                    width: 300,
                    borderColor: Colors.lightBlue[100],
                    borderRadius: 20,
                    borderThickness: 5,
                  ),
                ),

                // Botão de captura da câmera
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 80.0), // Aumenta o padding para acomodar a prévia
                    child: IconButton(
                      icon: Icon(Icons.camera_alt),
                      iconSize: 50.0,
                      color: const Color.fromARGB(255, 31, 32, 32),
                      onPressed: () {
                        _takePicture();
                      },
                    ),
                  ),
                ),

                // Prévia das cartas reconhecidas (imagens do Firestore)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 100, // Altura da prévia
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal, // Lista horizontal
                      itemCount: recognizedCards.length, // Número de cartas reconhecidas
                      itemBuilder: (context, index) {
                        var card = recognizedCards[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network(
                            card['imageUrl'], // Exibe a imagem da carta do Firestore
                            width: 100, // Define a largura da miniatura
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            )
          : Center(
              child:
                  CircularProgressIndicator(), // Indicador de carregamento enquanto a câmera inicializa
            ),
    );
  }
}
