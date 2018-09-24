import 'package:dengue_app/logic/user.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LeaderBoard extends StatelessWidget {
  LeaderBoard({@required this.user});

  @override
  Widget build(BuildContext context) {
    leaderBoard.sort((a, b) => b[1].compareTo(a[1]));
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            itemBuilder: (_, index) => ListTile(
                  title: Text(leaderBoard[index][0]),
                  subtitle:
                      Text("Points ${leaderBoard[index][1]}"),
                  leading: CircleAvatar(
                    child: Text("${index + 1}"),
                  ),
              trailing: _buildTrailingBadge(index),
                ),
            itemCount: leaderBoard.length,
          ),
        ),
        Container(
          color: Colors.amber,
          child: ListTile(
            title: Text(user.displayName),
            subtitle:
            Text("Points ${user.points}"),
            leading: CircleAvatar(
              child: Text("56"),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildTrailingBadge(int index){
    if (index>=10){
      return null;
    }else if (index>=3){
      return Icon(FontAwesomeIcons.gift);
    }else{
      return Icon(FontAwesomeIcons.medal);
    }
  }

  final User user;
  final List<List> leaderBoard = [
    ["Mario Speedwagon", 100],
    ["Petey Cruiser", 533],
    ["Anna Sthesia", 1002],
    ["Paul Molive", 2323],
    ["Anna Mull", 123],
    ["Gail Forcewind", 34],
    ["Paige Turner", 123],
    ["Bob Frapples", 5],
    ["Walter Melon", 324],
    ["Nick R. Bocker", 45],
    ["Barb Ackue", 87],
    ["Buck Kinnear", 45],
    ["Greta Life", 47],
    ["Ira Membrit", 97],
    ["Shonda Leer", 2],
    ["Brock Lee", 65],
  ];
}
