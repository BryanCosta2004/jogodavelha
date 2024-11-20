import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  static const String playerX = "X";
  static const String playerO = "O";

  late String currentPlayer;
  late bool isGameOver;
  late List<String> board;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    currentPlayer = playerX;
    isGameOver = false;
    board = List.filled(9, ""); // Board with 9 empty spaces
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tic Tac Toe"),
        backgroundColor: Colors.green,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildHeader(),
          _buildGameBoard(),
          _buildRestartButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const Text(
          "Tic Tac Toe",
          style: TextStyle(
            color: Colors.green,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "$currentPlayer's Turn",
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildGameBoard() {
    return Expanded(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        padding: const EdgeInsets.all(16),
        itemCount: 9,
        itemBuilder: (context, index) => _buildTile(index),
      ),
    );
  }

  Widget _buildTile(int index) {
    return GestureDetector(
      onTap: () => _onTileTapped(index),
      child: Container(
        decoration: BoxDecoration(
          color: board[index].isEmpty
              ? Colors.black26
              : board[index] == playerX
              ? Colors.blue
              : Colors.orange,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            board[index],
            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildRestartButton() {
    return ElevatedButton(
      onPressed: () => setState(_initializeGame),
      child: const Text("Restart Game"),
    );
  }

  void _onTileTapped(int index) {
    if (isGameOver || board[index].isNotEmpty) return;

    setState(() {
      board[index] = currentPlayer;
      _checkWinner();
      _checkDraw();
      if (!isGameOver) _switchPlayer();
    });
  }

  void _switchPlayer() {
    currentPlayer = (currentPlayer == playerX) ? playerO : playerX;
  }

  void _checkWinner() {
    const List<List<int>> winningCombinations = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var combination in winningCombinations) {
      final a = board[combination[0]];
      final b = board[combination[1]];
      final c = board[combination[2]];

      if (a.isNotEmpty && a == b && a == c) {
        _showGameOverMessage("Player $a Won!");
        isGameOver = true;
        return;
      }
    }
  }

  void _checkDraw() {
    if (isGameOver) return;

    if (!board.contains("")) {
      _showGameOverMessage("It's a Draw!");
      isGameOver = true;
    }
  }

  void _showGameOverMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18),
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}