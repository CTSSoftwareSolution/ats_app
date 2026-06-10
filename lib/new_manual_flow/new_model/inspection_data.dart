import 'inspection_model.dart';

class InspectionData {
  /// Returns all sections split into pre and post inspection
  static List<InspectionSection> buildSections() => [
    ...buildPreSections(),
    ...buildPostSections(),
  ];

  // ── PRE-INSPECTION ────────────────────────────────────────────────────────
  // Visual checks done BEFORE the vehicle enters the test lane
  static List<InspectionSection> buildPreSections() => [
    InspectionSection(
      id: 'pre_headlamps',
      title: 'HEADLAMPS & LAMPS',
      icon: '💡',
      phase: InspectionPhase.pre,
      items: [
        _item('02', 'Headlamps Assembly', 'Rule 105, AIS-008/AIS-009', [
          'Bulb should be working',
          'Head lamp operating switch working',
          'No broken lens',
          'Lens not painted with colour or pasted with sticker',
          'No moisture deposition on inside surface of lens',
        ]),
        _item('03-a', 'Top Lights', 'Rule 107, 108, AIS-008', [
          'Coloured lens shall not be faded',
          'Lens should not be broken',
          'Lamp shall be working',
          'For dual coloured lens: red lens to rear, white to front',
          'No moisture deposition on inside surface of lens',
          'Secured fitment of the lamps',
        ]),
        _item('03-b', 'Stop Lights', 'Rule 102, AIS-008/AIS-009', [
          'Coloured lens shall not be faded',
          'Lens should not be broken',
          'Lamp shall be working on actuation of the brake',
          'No moisture deposition on inside surface of lens',
          'Secured fitment of the lamps',
        ]),
        _item('03-c', 'Parking Lights', 'Rule 109, AIS-008/AIS-009', [
          'Colored lens shall not be faded',
          'Lens should not be broken',
          'Lamp shall be working',
          'No moisture deposition on inside surface of lens',
          'Secured fitment of the lamps',
        ]),
        _item('03-d', 'Fog Lamps (if fitted)', 'AIS-008', [
          'Coloured lens shall not be faded',
          'Lens should not be broken',
          'Lamp shall be working',
          'No moisture deposition on inside surface of lens',
          'Secured fitment of the lamps',
        ]),
        _item('03-f', 'Number Plate Light', 'Rule 108, AIS-008/AIS-009', [
          'White light shall be used for illuminating number plate',
          'Lens should not be broken',
          'Lamps shall be working',
          'No moisture deposition on inside surface of lens',
          'Secured fitment of the lamps',
        ]),
        _item('03-h', 'Direction Indicators', 'Rule 102, AIS-008/AIS-009', [
          'Flashing light emitted shall be Amber in colour',
          'Lens should not be broken',
          'Lamps shall be working',
          'No moisture deposition on inside surface of lens',
          'Secured fitment of the lamps',
        ]),
        _item('03-i', 'Hazard Warning Signal Lamp', 'AIS-008, AIS-009', [
          'Flashing light emitted shall be Amber in colour',
          'Ensure simultaneous operation of all direction indicator lamps by use of switch',
        ]),
      ],
    ),

    InspectionSection(
      id: 'pre_safety',
      title: 'SAFETY SYSTEMS',
      icon: '🛡️',
      phase: InspectionPhase.pre,
      items: [
        _item('04', 'Suppressor Cap / High Tension Cable', '—', [
          'Suppressor cap shall be in good condition',
          'High Tension cable shall be properly insulated',
          'Proper terminal connections on both sides of HT cable',
        ]),
        _item('05', 'Rear View Mirrors', 'Rule 125(2), AIS-002', [
          'Fitment of required class as per AIS 002 (Part-1)/(Part-2)(Rev-1)',
          'Symbol I/II/III/IV/V/VI/VII on mirror marking',
          'Secured fitment of mirrors in good condition',
        ]),
        _item('06', 'Safety Glass (Windscreen)', 'Rule 100, IS:2553 (Part 2)', [
          'Except FASTag/Permits/Badges area, windscreen glass shall be transparent',
          'Laminated safety glass bears clear indelible _LW or _II or IV or II/P marking',
          'Glass shall not be damaged/cracked',
          'Coloured films shall not be pasted on the glass',
        ]),
        _item('07', 'Horn', 'IS-1884, Rule 119, IS-15796', [
          'Multi-toned/harsh/shrill/loud/alarming horn shall NOT be used',
          'Horn shall be securely fitted',
          'Horn shall be functioning',
        ]),
        _item('09-a', 'Windscreen Wiper Blades', 'Rule 101, AIS-045', [
          'Ensure presence of wiper blades',
          'Wiper blade shall be in good condition',
        ]),
        _item('09-b', 'Windscreen Wiper System', 'Rule 101, AIS-045', [
          'Each wiper arm covers maximum area of windscreen',
          'Wiper shall be securely fitted',
        ]),
        _item('26', 'Safety Belt (Seatbelt)', 'Rule 125(1-A), AIS-015', [
          'Mandatory safety belts shall be available and securely fitted',
          'Safety belts shall not be damaged',
          'Safety belt anchorage shall not be loose',
          'Seatbelt reminder system, if available, should be functioning',
          'G-lock of seatbelt should be functioning',
        ]),
      ],
    ),

    InspectionSection(
      id: 'pre_body',
      title: 'VEHICLE BODY & EQUIPMENT',
      icon: '🚗',
      phase: InspectionPhase.pre,
      items: [
        _item('10', 'Dashboard Equipment', 'AIS-071 (Part 1)', [
          'Ensure secured mounting',
          'Wiring shall be insulated',
          'Dashboard illumination shall be functioning',
          'Warning lights (ABS, brakes, battery, OBD, fuel, oil, coolant) shall NOT remain illuminated',
        ]),
        _item('20', 'FASTag', 'Rule 138(A)', [
          'FASTag to be affixed on the front windscreen',
          'FASTag shall not be damaged',
        ]),
        _item('24', 'High Security Registration Plate (HSRP)', 'Rule 50, AIS-159', [
          'HSRP installed at front & rear of the vehicle',
          'Securely fixed',
        ]),
        _item('25', 'Battery', '—', [
          'Secured mounting',
          'Ensure no leakage',
          'Ensure top is clean, dry, free of dirt and grime',
        ]),
        _item('29', 'Tyres', 'Rule 94 and 95', [
          'Tyres shall not have any serious damage or cut',
          'NSD ≥ 0.8 mm (3-wheelers/E-rickshaw); ≥ 1.6 mm (other vehicles)',
          'Tyres shall be properly inflated',
          'Tyres shall not show signs of incipient failure',
          'Tyre casing fabric shall not be exposed',
          'Temporary spare wheel or tyre puncture repair kit shall be available',
        ]),
        _item('30', 'Retro-Reflector and Reflective Tapes', 'Rule 104, AIS-090', [
          'Reflectors present, clean, secured; not in damaged condition',
          'Colour: red to rear, white to front',
          'Reflective tapes present, securely pasted, size/colour/location as per rule 104',
          'Marks shall be visible and indelible',
        ]),
      ],
    ),

    InspectionSection(
      id: 'pre_silencer',
      title: 'SILENCER & EMISSION',
      icon: '💨',
      phase: InspectionPhase.pre,
      items: [
        _item('08-a', 'Silencer', 'Rule 120, IS10399:1998', [
          'Ensure no leakage',
          'Secured fitment of silencer',
          'Silencer shall not be excessively rusty or damaged',
        ]),
        _item('17-a', 'Speedometer', 'Rule 117, IS-11827-2008', [
          'Securely fitted',
          'Sufficiently illuminated',
          'Dial cover shall not be broken',
          'Indicator needle operational',
        ]),
      ],
    ),
  ];

  // ── POST-INSPECTION ───────────────────────────────────────────────────────
  // Checks done AFTER automated tests in the test lane
  static List<InspectionSection> buildPostSections() => [
    InspectionSection(
      id: 'post_brakes',
      title: 'BRAKES & STEERING',
      icon: '⚙️',
      phase: InspectionPhase.post,
      items: [
        _item('12-a', 'Service Brakes', 'AIS-128', [
          'Fittings shall be secured',
          'Brake hoses shall not be damaged or cracked',
          'No leakage of brake fluid',
          'Braking efficiency ≥ 27.23% (from roller brake tester)',
        ]),
        _item('12-b', 'Parking Brakes', 'AIS-128', [
          'Fittings shall be secured',
          'Brake hoses shall not be damaged or cracked',
          'No leakage of brake fluid',
        ]),
        _item('13', 'Steering Gear', 'Rule 98', [
          'Back-lash/Free play in steering gear ≤ 30 degrees',
        ]),
        _item('16', 'Joint Play Test — Suspension', '—', [
          'Secured attachment of springs and shock absorbers to chassis',
          'Springs shall not be damaged or fractured',
          'Shock absorbers shall not have any oil leakage',
          'No excessive wear in swivel pin or bushes at suspension joints',
          'Axle: secured fixing; not fractured or deformed',
          'Steering: check tie rod ends for play or loose joints/bushes',
        ]),
      ],
    ),

    InspectionSection(
      id: 'post_emission',
      title: 'EMISSION TEST RESULTS',
      icon: '🌿',
      phase: InspectionPhase.post,
      items: [
        _item('11-a', 'Exhaust Gas — CO% (Petrol/CNG/LPG)', 'Rule 115(2)(i)', [
          'Applicable for Petrol/CNG/LPG driven vehicles',
          'Record measured value from gas analyser',
        ]),
        _item('11-b', 'Exhaust Gas — HC ppm (Petrol/CNG/LPG)', 'Rule 115(2)(i)', [
          'Applicable for Petrol/CNG/LPG driven vehicles',
          'Record measured value from gas analyser',
        ]),
        _item('11-e', 'Smoke Density — Free Acceleration (Diesel)', 'Rule 115(2)(ii)', [
          'Applicable for Diesel vehicles only',
          'Record measured value from opacimeter',
        ]),
      ],
    ),

    InspectionSection(
      id: 'post_protection',
      title: 'PROTECTION DEVICES',
      icon: '🔆',
      phase: InspectionPhase.post,
      items: [
        _item('18', 'Rear Under Run Protection Device (RUPD)', 'Rule 124(1A), IS-14812-2005 [N2,N3,T3,T4]', [
          'RUPD shall be fitted',
          'Not cracked, corroded or damaged',
          'Ground clearance and dimensions as per IS-14812-2005',
        ]),
        _item('19', 'Lateral Under Run Protection Device (LUPD)', 'Rule 124(1A), IS-14682-2004 [N2,N3,T3,T4]', [
          'LUPD shall be fitted',
          'Not cracked, corroded or damaged',
          'Dimensions as per IS-14682-2004',
        ]),
        _item('27', 'Speed Governor', 'Rule 118, AIS-018', [
          'Securely fitted',
          'Speed governor shall be sealed',
          'Electrical wirings shall not be disconnected',
        ]),
        _item('28', 'Spray Suppression Devices', 'AIS-013 (Rev.1)', [
          'Ensure presence of securely fitted spray suppression devices',
        ]),
      ],
    ),

    InspectionSection(
      id: 'post_ev',
      title: 'ELECTRIC VEHICLE (if applicable)',
      icon: '⚡',
      phase: InspectionPhase.post,
      items: [
        _item('31', 'Protection Against Electric Shock (EV)', 'AIS-038 (Rev.1)', [
          'Ensure access probe shall not touch live parts',
          'IPXXB test: jointed test finger may penetrate to 80mm length but stop face shall not pass through opening',
          'IPXXD test inside passenger compartment: access probe may penetrate full length but stop face shall not fully penetrate',
        ]),
        _item('32', 'Insulation Resistance Measurement (EV)', 'AIS-038 (Rev.1)', [
          'Insulation resistance measured should be greater than 500Ω/V',
        ]),
        _item('33', 'State of Charge (SOC) Indicator (EV)', 'AIS-038 (Rev.1)', [
          'Manufacturer supplied SOC indicator shall be in working condition',
        ]),
      ],
    ),
  ];

  static InspectionItem _item(String ref, String name, String rule, List<String> params) =>
      InspectionItem(ref: ref, name: name, ruleRef: rule, params: params);
}
