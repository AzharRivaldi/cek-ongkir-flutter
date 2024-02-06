import 'dart:convert';

import 'package:cek_ongkir/model/model_kota.dart';
import 'package:cek_ongkir/page/detail_page.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var strKey = "";
  var strKotaAsal;
  var strKotaTujuan;
  var strBerat;
  var strEkspedisi;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cek Ongkos Kirim"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownSearch<ModelKota>(
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: "Kota Asal",
                  hintText: "Pilih Kota Asal",
                ),
              ),
              popupProps: const PopupProps.menu(
                showSearchBox: true,
              ),
              onChanged: (value) {
                strKotaAsal = value?.cityId;
              },
              itemAsString: (item) => "${item.type} ${item.cityName}",
              asyncItems: (text) async {
                var response = await http.get(Uri.parse("https://api.rajaongkir.com/starter/city?key=${strKey}"));
                List allKota = (jsonDecode(response.body) as Map<String, dynamic>)['rajaongkir']['results'];
                var dataKota = ModelKota.fromJsonList(allKota);
                return dataKota;
              },
            ),
            const SizedBox(height: 20),
            DropdownSearch<ModelKota>(
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: "Kota Tujuan",
                  hintText: "Pilih Kota Tujuan",
                ),
              ),
              popupProps: const PopupProps.menu(
                showSearchBox: true,
              ),
              onChanged: (value) {
                strKotaTujuan = value?.cityId;
              },
              itemAsString: (item) => "${item.type} ${item.cityName}",
              asyncItems: (text) async {
                var response = await http.get(Uri.parse("https://api.rajaongkir.com/starter/city?key=${strKey}"));
                List allKota = (jsonDecode(response.body) as Map<String, dynamic>)['rajaongkir']['results'];
                var dataKota = ModelKota.fromJsonList(allKota);
                return dataKota;
              },
            ),
            const SizedBox(height: 20),
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Berat Paket (gram)",
                hintText: "Input Berat Paket",
              ),
              onChanged: (text) {
                strBerat = text;
              },
            ),
            const SizedBox(height: 20),
            DropdownSearch<String>(
                items: const ["JNE", "TIKI", "POS"],
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: "Kurir",
                    hintText: "Kurir",
                  ),
                ),
                popupProps: PopupPropsMultiSelection.menu(
                  showSelectedItems: true,
                  disabledItemFn: (String s) => s.startsWith('I'),
                ),
                onChanged: (text) {
                  strEkspedisi = text?.toLowerCase();
                }),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.blue),
                  child: Material(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        if (strKotaAsal == null || strKotaTujuan == null
                            || strBerat == null || strEkspedisi == null)
                        {
                          const snackBar = SnackBar(content: Text("Ups, form tidak boleh kosong!"));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                        else {
                          Navigator.push(context,
                            MaterialPageRoute(
                                builder: (context) => DetailPage(
                                      kota_asal: strKotaAsal,
                                      kota_tujuan: strKotaTujuan,
                                      berat: strBerat,
                                      kurir: strEkspedisi,
                                    )),
                          );
                        }
                      },
                      child: const Center(
                        child: Text("Cek Ongkir",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
