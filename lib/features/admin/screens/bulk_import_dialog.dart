import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';
import '../models/admin_building.dart';
import '../models/property.dart';
import '../services/bulk_import_service.dart';

enum ImportType { properties, buildings }

class BulkImportDialog extends StatefulWidget {
  const BulkImportDialog({super.key});

  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const BulkImportDialog(),
    );
  }

  @override
  State<BulkImportDialog> createState() => _BulkImportDialogState();
}

class _BulkImportDialogState extends State<BulkImportDialog> {
  ImportType _importType = ImportType.properties;
  final _jsonController = TextEditingController();

  /// Empty string means "auto": every item keeps the area from its own JSON.
  static const String _autoArea = '';
  String _overrideArea = _autoArea;

  bool _isAnalyzing = false;
  bool _isUploading = false;
  int _uploadCurrent = 0;
  int _uploadTotal = 0;

  BulkImportReport<Property>? _propertyReport;
  BulkImportReport<AdminBuilding>? _buildingReport;

  static const String _samplePropertyJson = '''[
  {
    "projectName": "شقة 125م جاردنيا هايتس 2",
    "area": "جاردينيا",
    "buildingLabel": null,
    "unitType": "شقة",
    "floor": "تاني",
    "orientation": null,
    "areaSqm": 125,
    "bedrooms": 2,
    "bathrooms": 1,
    "hasReception": true,
    "hasKitchen": true,
    "finishingStatus": "نص تشطيب",
    "price": 2675000,
    "priceNote": "بالعداد",
    "priceUsd": null,
    "description": "شقة دور تاني، غرفتين وريسبشن وحمام ومطبخ",
    "facadeImageUrl": "https://res.cloudinary.com/pirtgu9c/image/upload/v1786371432/WhatsApp_Image_2026-08-07_at_9.42.15_PM.jpg",
    "detailImageUrls": [
      "https://res.cloudinary.com/pirtgu9c/image/upload/v1786464780/WhatsApp_Image_2026-08-11_at_12.32.01_AM.jpg"
    ],
    "videoUrl": null,
    "isPublished": true
  }
]''';

  static const String _sampleBuildingJson = '''[
  {
    "name": "عمارة جاردنيا هايتس 3 - حرف أ",
    "area": "جاردينيا",
    "description": "عمارة كاملة، مبنية بيزمنت وأرضي وأول، دبل فيس، الدور ينفع شقتين.",
    "startingPrice": 18500000,
    "areaSqm": 286,
    "buildingStructure": "بيزمنت + أرضي + أول",
    "orientation": "دبل فيس",
    "layoutNote": "الدور ينفع شقتين",
    "totalFloors": 3,
    "totalUnits": 6,
    "availableUnits": 6,
    "finishingStatus": "semiFinished",
    "amenities": [],
    "facadeImageUrl": "https://res.cloudinary.com/pirtgu9c/image/upload/v1786464780/WhatsApp_Image_2026-08-11_at_12.32.01_AM.jpg",
    "detailImageUrls": [
      "https://res.cloudinary.com/pirtgu9c/image/upload/v1786464781/WhatsApp_Image_2026-08-11_at_12.32.02_AM.jpg",
      "https://res.cloudinary.com/pirtgu9c/image/upload/v1786464782/WhatsApp_Image_2026-08-11_at_12.32.03_AM.jpg"
    ],
    "videoUrl": null,
    "isPublished": true
  }
]''';

  @override
  void dispose() {
    _jsonController.dispose();
    super.dispose();
  }

  void _clearReports() {
    setState(() {
      _propertyReport = null;
      _buildingReport = null;
    });
  }

  /// Guesses whether the pasted JSON is a list of buildings or apartments by
  /// looking at the first item's fields. Returns null when it cannot tell.
  ImportType? _detectImportType(String rawJson) {
    dynamic decoded;
    try {
      decoded = jsonDecode(rawJson);
    } catch (_) {
      return null;
    }
    final list = decoded is List ? decoded : [decoded];
    if (list.isEmpty) return null;
    final first = list.first;
    if (first is! Map) return null;
    final item = Map<String, dynamic>.from(first);

    final hasBuildingMarkers = [
      'buildingStructure',
      'availableUnits',
      'layoutNote',
      'amenities',
    ].any(item.containsKey);

    final unitType = (item['unitType'] as String?)?.trim();
    final isBuildingUnit =
        unitType == 'عمارة' || unitType == 'عماره';
    final isApartmentUnit = unitType != null &&
        ['شقة', 'دوبلكس', 'فيلا', 'استوديو'].contains(unitType);
    final hasApartmentMarkers = [
      'bedrooms',
      'priceNote',
      'hasReception',
    ].any(item.containsKey);

    if (hasBuildingMarkers) return ImportType.buildings;
    if (isBuildingUnit && hasApartmentMarkers) return ImportType.properties;
    if (isApartmentUnit || hasApartmentMarkers) return ImportType.properties;
    return null;
  }

  void _loadSampleData() {
    _jsonController.text = _importType == ImportType.properties
        ? _samplePropertyJson
        : _sampleBuildingJson;
    _analyzeJson();
  }

  void _copyTemplate() {
    final text = _importType == ImportType.properties
        ? _samplePropertyJson
        : _sampleBuildingJson;
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _importType == ImportType.properties
              ? 'تم نسخ نموذج JSON للشقق إلى الحافظة 📋'
              : 'تم نسخ نموذج JSON للعمارات إلى الحافظة 📋',
        ),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _analyzeJson() {
    final text = _jsonController.text.trim();
    if (text.isEmpty) {
      _clearReports();
      return;
    }

    // Auto-switch to the correct tab based on the pasted JSON so buildings
    // never get saved into the apartments collection (and vice versa).
    final detected = _detectImportType(text);
    if (detected != null && detected != _importType) {
      _importType = detected;
      _clearReports();
    }

    setState(() {
      _isAnalyzing = true;
    });

    if (_importType == ImportType.properties) {
      final report = BulkImportService.instance.parsePropertiesJson(text);
      setState(() {
        _propertyReport = report;
        _buildingReport = null;
        _isAnalyzing = false;
      });
    } else {
      final report = BulkImportService.instance.parseBuildingsJson(text);
      setState(() {
        _buildingReport = report;
        _propertyReport = null;
        _isAnalyzing = false;
      });
    }
  }

  Future<void> _startImport() async {
    final propValid = _propertyReport?.validItems ?? [];
    final buildValid = _buildingReport?.validItems ?? [];

    if (_importType == ImportType.properties && propValid.isEmpty) return;
    if (_importType == ImportType.buildings && buildValid.isEmpty) return;

    setState(() {
      _isUploading = true;
      _uploadCurrent = 0;
      _uploadTotal = _importType == ImportType.properties
          ? propValid.length
          : buildValid.length;
    });

    try {
      final overrideArea = _overrideArea.trim().isEmpty ? null : _overrideArea.trim();
      if (_importType == ImportType.properties) {
        await BulkImportService.instance.uploadPropertiesInBulk(
          propValid,
          overrideArea: overrideArea,
          onProgress: (current, total) {
            if (mounted) {
              setState(() {
                _uploadCurrent = current;
                _uploadTotal = total;
              });
            }
          },
        );
      } else {
        await BulkImportService.instance.uploadBuildingsInBulk(
          buildValid,
          overrideArea: overrideArea,
          onProgress: (current, total) {
            if (mounted) {
              setState(() {
                _uploadCurrent = current;
                _uploadTotal = total;
              });
            }
          },
        );
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'تم رفع $_uploadTotal ${_importType == ImportType.properties ? "شقة/وحدة" : "عمارة"} بنجاح إلى الفايربيز 🚀',
          ),
          backgroundColor: AppColors.success,
          duration: const Duration(seconds: 4),
        ),
      );
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isUploading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ أثناء الرفع: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final validCount = _importType == ImportType.properties
        ? (_propertyReport?.validItems.length ?? 0)
        : (_buildingReport?.validItems.length ?? 0);

    final errorList = _importType == ImportType.properties
        ? (_propertyReport?.errors ?? [])
        : (_buildingReport?.errors ?? []);

    final totalParsed = _importType == ImportType.properties
        ? (_propertyReport?.totalParsed ?? 0)
        : (_buildingReport?.totalParsed ?? 0);

    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.divider),
      ),
      child: Container(
        width: 720,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.88,
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Header ──────────────────────────────────────────────
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.accentLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.upload_file_rounded,
                    color: AppColors.accent,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'الرفع الجماعي من كود JSON 📄',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'ارفع مئات الشقق أو العمارات دفعة واحدة إلى الداتا بيز',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: AppColors.textSecondary.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                if (!_isUploading)
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    icon: const Icon(Icons.close_rounded,
                        color: AppColors.textSecondary),
                  ),
              ],
            ),
            const SizedBox(height: 18),

            // ── Import Type Segment Selector ────────────────────────
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Center(
                      child: Text('شقق ووحدات (Properties)'),
                    ),
                    selected: _importType == ImportType.properties,
                    selectedColor: AppColors.accent,
                    backgroundColor: AppColors.cream,
                    labelStyle: TextStyle(
                      color: _importType == ImportType.properties
                          ? AppColors.textOnPrimary
                          : AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                    onSelected: (selected) {
                      if (selected && !_isUploading) {
                        setState(() {
                          _importType = ImportType.properties;
                          _clearReports();
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ChoiceChip(
                    label: const Center(
                      child: Text('عمارات بالكامل (Buildings)'),
                    ),
                    selected: _importType == ImportType.buildings,
                    selectedColor: const Color(0xFF7C3AED),
                    backgroundColor: AppColors.cream,
                    labelStyle: TextStyle(
                      color: _importType == ImportType.buildings
                          ? Colors.white
                          : AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                    onSelected: (selected) {
                      if (selected && !_isUploading) {
                        setState(() {
                          _importType = ImportType.buildings;
                          _clearReports();
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // ── Target Area Selector ────────────────────────────────
            DropdownButtonFormField<String>(
              initialValue: _overrideArea,
              isExpanded: true,
              dropdownColor: AppColors.surface,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                labelText: 'المكان / المنطقة للإضافة',
                hintText: 'اختر المنطقة...',
                helperText: 'اختر المنطقة قبل الرفع لتخزين كل الداتا في مكانها الصحيح',
                filled: true,
                fillColor: AppColors.cream,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.divider),
                ),
              ),
              items: [
                DropdownMenuItem<String>(
                  value: _autoArea,
                  child: const Text('تلقائي (حسب منطقة كل عنصر في الكود)'),
                ),
                ...areaOptions.map(
                  (area) => DropdownMenuItem<String>(
                    value: area,
                    child: Text(area),
                  ),
                ),
              ],
              onChanged: _isUploading
                  ? null
                  : (value) {
                      setState(() {
                        _overrideArea = value ?? _autoArea;
                      });
                    },
            ),
            const SizedBox(height: 14),

            // ── Toolbar Quick Actions ───────────────────────────────
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: _isUploading ? null : _copyTemplate,
                  icon: const Icon(Icons.copy_rounded, size: 16),
                  label: const Text('نسخ نموذج JSON القالب'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: _isUploading ? null : _loadSampleData,
                  icon: const Icon(Icons.playlist_add_check_rounded, size: 16),
                  label: const Text('تعبئة نموذج تجريبي'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                  ),
                ),
                if (_jsonController.text.isNotEmpty)
                  TextButton.icon(
                    onPressed: _isUploading
                        ? null
                        : () {
                            _jsonController.clear();
                            _clearReports();
                          },
                    icon: const Icon(Icons.clear_all_rounded, size: 16),
                    label: const Text('مسح النص'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.error,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),

            // ── JSON Text Editor ────────────────────────────────────
            Expanded(
              child: Stack(
                children: [
                  TextField(
                    controller: _jsonController,
                    enabled: !_isUploading,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 13,
                      color: AppColors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: _importType == ImportType.properties
                          ? 'الصق كود الـ JSON هنا (مصفوفة) — صورة الواجه في facadeImageUrl وباقي صور الشقة في detailImageUrls'
                          : 'الصق كود الـ JSON هنا (مصفوفة) — صورة الواجه في facadeImageUrl وباقي صور العمارة في detailImageUrls',
                      filled: true,
                      fillColor: AppColors.cream,
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.divider),
                      ),
                    ),
                    onChanged: (_) => _analyzeJson(),
                  ),
                  if (_isAnalyzing)
                    const Positioned(
                      top: 12,
                      left: 12,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.accent,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // ── Validation & Diagnostic Summary ─────────────────────
            if (totalParsed > 0 || errorList.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: errorList.isEmpty
                      ? AppColors.success.withValues(alpha: 0.1)
                      : AppColors.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: errorList.isEmpty
                        ? AppColors.success.withValues(alpha: 0.4)
                        : AppColors.warning.withValues(alpha: 0.4),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          errorList.isEmpty
                              ? Icons.check_circle_rounded
                              : Icons.warning_amber_rounded,
                          color: errorList.isEmpty
                              ? AppColors.success
                              : AppColors.warning,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'نتائج فحص الكود: تم العثور على $totalParsed عنصر | جاهز للرفع: $validCount',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13.5,
                            color: errorList.isEmpty
                                ? AppColors.success
                                : AppColors.warning,
                          ),
                        ),
                      ],
                    ),
                    if (errorList.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      ...errorList.take(3).map(
                            (err) => Text(
                              '• $err',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.error,
                              ),
                            ),
                          ),
                      if (errorList.length > 3)
                        Text(
                          'و وهناك ${errorList.length - 3} أخطاء أخرى...',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textHint,
                          ),
                        ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],

            // ── Upload Progress Bar ─────────────────────────────────
            if (_isUploading) ...[
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'جاري رفع البيانات إلى الفايربيز...',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.accent,
                        ),
                      ),
                      Text(
                        '$_uploadCurrent / $_uploadTotal',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: _uploadTotal > 0 ? _uploadCurrent / _uploadTotal : 0,
                    backgroundColor: AppColors.divider,
                    color: AppColors.accent,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
              const SizedBox(height: 14),
            ],

            // ── Dialog Bottom Action Buttons ────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _isUploading
                      ? null
                      : () => Navigator.of(context).pop(false),
                  child: const Text('إلغاء'),
                ),
                const SizedBox(width: 12),
                FilledButton.icon(
                  onPressed: (_isUploading || validCount == 0)
                      ? null
                      : _startImport,
                  style: FilledButton.styleFrom(
                    backgroundColor: _importType == ImportType.properties
                        ? AppColors.accent
                        : const Color(0xFF7C3AED),
                    foregroundColor: _importType == ImportType.properties
                        ? AppColors.textOnPrimary
                        : Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                  ),
                  icon: _isUploading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.cloud_upload_rounded, size: 20),
                  label: Text(
                    _isUploading
                        ? 'جاري الرفع...'
                        : 'رفع $validCount ${_importType == ImportType.properties ? "شقة" : "عمارة"} إلى الفايربيز 🚀',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
