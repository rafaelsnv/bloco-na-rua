// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:bloco_na_rua/domain/models/api/carnival_block/carnival_block_create.dart';
import 'package:bloco_na_rua/domain/models/api/carnival_block/carnival_block_update.dart';
import 'package:bloco_na_rua/domain/models/api/carnival_block_member/carnival_block_member_create.dart';
import 'package:bloco_na_rua/domain/models/api/carnival_block_member/carnival_block_member_update.dart';
import 'package:bloco_na_rua/domain/models/api/meeting/meeting_create.dart';
import 'package:bloco_na_rua/domain/models/api/meeting/meeting_update.dart';
import 'package:bloco_na_rua/domain/models/api/meeting_presence/meeting_presence_create.dart';
import 'package:bloco_na_rua/domain/models/api/meeting_presence/meeting_presence_update.dart';
import 'package:bloco_na_rua/domain/models/api/member/member_create.dart';
import 'package:bloco_na_rua/domain/models/api/member/member_update.dart';
import 'package:bloco_na_rua/utils/result.dart';

class ApiClient {
  ApiClient({String? host, int? port, HttpClient Function()? clientFactory})
    : _host = host ?? 'localhost',
      _port = port ?? 8080,
      _clientFactory = clientFactory ?? HttpClient.new;

  final String _host;
  final int _port;
  final HttpClient Function() _clientFactory;

  // CarnivalBlocks endpoints
  Future<Result<List<Map<String, dynamic>>>> getCarnivalBlocks() async {
    final client = _clientFactory();
    try {
      final request = await client.get(_host, _port, '/api/v1/CarnivalBlocks');
      final response = await request.close();
      if (response.statusCode == 200) {
        final responseBody = await response.transform(utf8.decoder).join();
        final List<dynamic> jsonList = jsonDecode(responseBody);
        final List<Map<String, dynamic>> blocks = jsonList.cast<Map<String, dynamic>>();
        return Result.ok(blocks);
      } else {
        return const Result.error(HttpException("Invalid response"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }

  Future<Result<Map<String, dynamic>>> getCarnivalBlock(int id) async {
    final client = _clientFactory();
    try {
      final request = await client.get(_host, _port, '/api/v1/CarnivalBlocks/$id');
      final response = await request.close();
      if (response.statusCode == 200) {
        final responseBody = await response.transform(utf8.decoder).join();
        final Map<String, dynamic> block = jsonDecode(responseBody);
        return Result.ok(block);
      } else {
        return const Result.error(HttpException("Invalid response"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }

  Future<Result<void>> createCarnivalBlock(
    CarnivalBlockCreate carnivalBlock,
  ) async {
    final client = _clientFactory();
    try {
      final request = await client.post(_host, _port, '/api/v1/CarnivalBlocks');
      request.headers.contentType = ContentType.json;
      request.write(jsonEncode(carnivalBlock.toJson()));
      final response = await request.close();
      if (response.statusCode == 200) {
        return const Result.ok(null);
      } else {
        return const Result.error(HttpException("Invalid response"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }

  Future<Result<void>> updateCarnivalBlock(
    int id,
    CarnivalBlockUpdate carnivalBlock,
    int loggedMemberId,
  ) async {
    final client = _clientFactory();
    try {
      final request = await client.put(
        _host,
        _port,
        '/api/v1/CarnivalBlocks/$id',
      );
      request.headers.contentType = ContentType.json;
      request.headers.add('X-Logged-Member', loggedMemberId.toString());
      request.write(jsonEncode(carnivalBlock.toJson()));
      final response = await request.close();
      if (response.statusCode == 200) {
        return const Result.ok(null);
      } else {
        return const Result.error(HttpException("Invalid response"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }

  Future<Result<void>> deleteCarnivalBlock(int id, int loggedMemberId) async {
    final client = _clientFactory();
    try {
      final request = await client.delete(
        _host,
        _port,
        '/api/v1/CarnivalBlocks/$id',
      );
      request.headers.add('X-Logged-Member', loggedMemberId.toString());
      final response = await request.close();
      if (response.statusCode == 200) {
        return const Result.ok(null);
      } else {
        return const Result.error(HttpException("Invalid response"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }

  // CarnivalBlockMembers endpoints
  Future<Result<List<Map<String, dynamic>>>> getCarnivalBlockMembers() async {
    final client = _clientFactory();
    try {
      final request = await client.get(_host, _port, '/api/v1/CarnivalBlockMembers');
      final response = await request.close();
      if (response.statusCode == 200) {
        final responseBody = await response.transform(utf8.decoder).join();
        final List<dynamic> jsonList = jsonDecode(responseBody);
        final List<Map<String, dynamic>> members = jsonList.cast<Map<String, dynamic>>();
        return Result.ok(members);
      } else {
        return const Result.error(HttpException("Invalid response"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }

  Future<Result<List<Map<String, dynamic>>>> getCarnivalBlockMembersByBlock(int blockId) async {
    final client = _clientFactory();
    try {
      final request = await client.get(_host, _port, '/api/v1/CarnivalBlockMembers/block/$blockId');
      final response = await request.close();
      if (response.statusCode == 200) {
        final responseBody = await response.transform(utf8.decoder).join();
        final List<dynamic> jsonList = jsonDecode(responseBody);
        final List<Map<String, dynamic>> members = jsonList.cast<Map<String, dynamic>>();
        return Result.ok(members);
      } else {
        return const Result.error(HttpException("Invalid response"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }

  Future<Result<void>> createCarnivalBlockMember(
    CarnivalBlockMemberCreate member,
    int loggedMemberId,
  ) async {
    final client = _clientFactory();
    try {
      final request = await client.post(_host, _port, '/api/v1/CarnivalBlockMembers');
      request.headers.contentType = ContentType.json;
      request.headers.add('X-Logged-Member', loggedMemberId.toString());
      request.write(jsonEncode(member.toJson()));
      final response = await request.close();
      if (response.statusCode == 200) {
        return const Result.ok(null);
      } else {
        return const Result.error(HttpException("Invalid response"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }

  Future<Result<void>> updateCarnivalBlockMember(
    int id,
    CarnivalBlockMemberUpdate member,
    int loggedMemberId,
  ) async {
    final client = _clientFactory();
    try {
      final request = await client.put(
        _host,
        _port,
        '/api/v1/CarnivalBlockMembers/$id',
      );
      request.headers.contentType = ContentType.json;
      request.headers.add('X-Logged-Member', loggedMemberId.toString());
      request.write(jsonEncode(member.toJson()));
      final response = await request.close();
      if (response.statusCode == 200) {
        return const Result.ok(null);
      } else {
        return const Result.error(HttpException("Invalid response"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }

  Future<Result<void>> deleteCarnivalBlockMember(int id, int loggedMemberId) async {
    final client = _clientFactory();
    try {
      final request = await client.delete(
        _host,
        _port,
        '/api/v1/CarnivalBlockMembers/$id',
      );
      request.headers.add('X-Logged-Member', loggedMemberId.toString());
      final response = await request.close();
      if (response.statusCode == 200) {
        return const Result.ok(null);
      } else {
        return const Result.error(HttpException("Invalid response"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }

  // Members endpoints
  Future<Result<List<Map<String, dynamic>>>> getMembers() async {
    final client = _clientFactory();
    try {
      final request = await client.get(_host, _port, '/api/v1/Members');
      final response = await request.close();
      if (response.statusCode == 200) {
        final responseBody = await response.transform(utf8.decoder).join();
        final List<dynamic> jsonList = jsonDecode(responseBody);
        final List<Map<String, dynamic>> members = jsonList.cast<Map<String, dynamic>>();
        return Result.ok(members);
      } else {
        return const Result.error(HttpException("Invalid response"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }

  Future<Result<Map<String, dynamic>>> getMember(int id) async {
    final client = _clientFactory();
    try {
      final request = await client.get(_host, _port, '/api/v1/Members/$id');
      final response = await request.close();
      if (response.statusCode == 200) {
        final responseBody = await response.transform(utf8.decoder).join();
        final Map<String, dynamic> member = jsonDecode(responseBody);
        return Result.ok(member);
      } else {
        return const Result.error(HttpException("Invalid response"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }

  Future<Result<void>> createMember(MemberCreate member) async {
    final client = _clientFactory();
    try {
      final request = await client.post(_host, _port, '/api/v1/Members');
      request.headers.contentType = ContentType.json;
      request.write(jsonEncode(member.toJson()));
      final response = await request.close();
      if (response.statusCode == 200) {
        return const Result.ok(null);
      } else {
        return const Result.error(HttpException("Invalid response"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }

  Future<Result<void>> updateMember(
    int id,
    MemberUpdate member,
    int loggedMemberId,
  ) async {
    final client = _clientFactory();
    try {
      final request = await client.put(
        _host,
        _port,
        '/api/v1/Members/$id',
      );
      request.headers.contentType = ContentType.json;
      request.headers.add('X-Logged-Member', loggedMemberId.toString());
      request.write(jsonEncode(member.toJson()));
      final response = await request.close();
      if (response.statusCode == 200) {
        return const Result.ok(null);
      } else {
        return const Result.error(HttpException("Invalid response"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }

  Future<Result<void>> deleteMember(int id, int loggedMemberId) async {
    final client = _clientFactory();
    try {
      final request = await client.delete(
        _host,
        _port,
        '/api/v1/Members/$id',
      );
      request.headers.add('X-Logged-Member', loggedMemberId.toString());
      final response = await request.close();
      if (response.statusCode == 200) {
        return const Result.ok(null);
      } else {
        return const Result.error(HttpException("Invalid response"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }

  // Meetings endpoints
  Future<Result<List<Map<String, dynamic>>>> getMeetings() async {
    final client = _clientFactory();
    try {
      final request = await client.get(_host, _port, '/api/v1/Meetings');
      final response = await request.close();
      if (response.statusCode == 200) {
        final responseBody = await response.transform(utf8.decoder).join();
        final List<dynamic> jsonList = jsonDecode(responseBody);
        final List<Map<String, dynamic>> meetings = jsonList.cast<Map<String, dynamic>>();
        return Result.ok(meetings);
      } else {
        return const Result.error(HttpException("Invalid response"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }

  Future<Result<List<Map<String, dynamic>>>> getMeetingsByBlock(int blockId) async {
    final client = _clientFactory();
    try {
      final request = await client.get(_host, _port, '/api/v1/Meetings/block/$blockId');
      final response = await request.close();
      if (response.statusCode == 200) {
        final responseBody = await response.transform(utf8.decoder).join();
        final List<dynamic> jsonList = jsonDecode(responseBody);
        final List<Map<String, dynamic>> meetings = jsonList.cast<Map<String, dynamic>>();
        return Result.ok(meetings);
      } else {
        return const Result.error(HttpException("Invalid response"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }

  Future<Result<void>> createMeeting(
    MeetingCreate meeting,
    int loggedMemberId,
  ) async {
    final client = _clientFactory();
    try {
      final request = await client.post(_host, _port, '/api/v1/Meetings');
      request.headers.contentType = ContentType.json;
      request.headers.add('X-Logged-Member', loggedMemberId.toString());
      request.write(jsonEncode(meeting.toJson()));
      final response = await request.close();
      if (response.statusCode == 200) {
        return const Result.ok(null);
      } else {
        return const Result.error(HttpException("Invalid response"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }

  Future<Result<void>> updateMeeting(
    int id,
    MeetingUpdate meeting,
    int loggedMemberId,
  ) async {
    final client = _clientFactory();
    try {
      final request = await client.put(
        _host,
        _port,
        '/api/v1/Meetings/$id',
      );
      request.headers.contentType = ContentType.json;
      request.headers.add('X-Logged-Member', loggedMemberId.toString());
      request.write(jsonEncode(meeting.toJson()));
      final response = await request.close();
      if (response.statusCode == 200) {
        return const Result.ok(null);
      } else {
        return const Result.error(HttpException("Invalid response"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }

  Future<Result<void>> deleteMeeting(int id, int loggedMemberId) async {
    final client = _clientFactory();
    try {
      final request = await client.delete(
        _host,
        _port,
        '/api/v1/Meetings/$id',
      );
      request.headers.add('X-Logged-Member', loggedMemberId.toString());
      final response = await request.close();
      if (response.statusCode == 200) {
        return const Result.ok(null);
      } else {
        return const Result.error(HttpException("Invalid response"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }

  // MeetingPresences endpoints
  Future<Result<List<Map<String, dynamic>>>> getMeetingPresences() async {
    final client = _clientFactory();
    try {
      final request = await client.get(_host, _port, '/api/v1/MeetingPresences');
      final response = await request.close();
      if (response.statusCode == 200) {
        final responseBody = await response.transform(utf8.decoder).join();
        final List<dynamic> jsonList = jsonDecode(responseBody);
        final List<Map<String, dynamic>> presences = jsonList.cast<Map<String, dynamic>>();
        return Result.ok(presences);
      } else {
        return const Result.error(HttpException("Invalid response"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }

  Future<Result<Map<String, dynamic>>> getMeetingPresence(int id) async {
    final client = _clientFactory();
    try {
      final request = await client.get(_host, _port, '/api/v1/MeetingPresences/$id');
      final response = await request.close();
      if (response.statusCode == 200) {
        final responseBody = await response.transform(utf8.decoder).join();
        final Map<String, dynamic> presence = jsonDecode(responseBody);
        return Result.ok(presence);
      } else {
        return const Result.error(HttpException("Invalid response"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }

  Future<Result<void>> createMeetingPresence(
    MeetingPresenceCreate presence,
    int loggedMemberId,
  ) async {
    final client = _clientFactory();
    try {
      final request = await client.post(_host, _port, '/api/v1/MeetingPresences');
      request.headers.contentType = ContentType.json;
      request.headers.add('X-Logged-Member', loggedMemberId.toString());
      request.write(jsonEncode(presence.toJson()));
      final response = await request.close();
      if (response.statusCode == 200) {
        return const Result.ok(null);
      } else {
        return const Result.error(HttpException("Invalid response"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }

  Future<Result<void>> updateMeetingPresence(
    int id,
    MeetingPresenceUpdate presence,
    int loggedMemberId,
  ) async {
    final client = _clientFactory();
    try {
      final request = await client.put(
        _host,
        _port,
        '/api/v1/MeetingPresences/$id',
      );
      request.headers.contentType = ContentType.json;
      request.headers.add('X-Logged-Member', loggedMemberId.toString());
      request.write(jsonEncode(presence.toJson()));
      final response = await request.close();
      if (response.statusCode == 200) {
        return const Result.ok(null);
      } else {
        return const Result.error(HttpException("Invalid response"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }

  Future<Result<void>> deleteMeetingPresence(int id, int loggedMemberId) async {
    final client = _clientFactory();
    try {
      final request = await client.delete(
        _host,
        _port,
        '/api/v1/MeetingPresences/$id',
      );
      request.headers.add('X-Logged-Member', loggedMemberId.toString());
      final response = await request.close();
      if (response.statusCode == 200) {
        return const Result.ok(null);
      } else {
        return const Result.error(HttpException("Invalid response"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }
}
