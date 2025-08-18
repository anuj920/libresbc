### LibreSBC Configuration for sip.unpod.tel

This configuration sets up LibreSBC for the sip.unpod.tel domain with the following network topology:

**Network Configuration:**
- LibreSBC Public IP: 159.65.154.134 (sip.unpod.tel)
- LibreSBC Private IP (eth0): 10.47.0.8
- LibreSBC Private IP (eth1): 10.122.0.7
- Carrier IP: 159.65.144.17
- PBX (vapi) IP: 44.229.228.186

**Topology:**
```
Public Users → 159.65.154.134 (sip.unpod.tel) → 10.47.0.8/10.122.0.7 → Carrier (159.65.144.17) / PBX vapi (44.229.228.186)
```

### Configuration Steps

The configuration follows these main steps:

1. **Network Setup**: Define network aliases for external and internal interfaces
2. **Domain & Access**: Configure domain policy and access service for sip.unpod.tel
3. **SIP Profiles**: Create SIP profiles for internal and external communication
4. **Media & Capacity**: Define media classes and capacity limits
5. **Gateways**: Configure gateways for carrier and PBX routing
6. **Interconnections**: Set up outbound connections to carrier and PBX
7. **Routing**: Define routing tables for call direction

### Files Description

- `config.sh`: Main configuration script that applies all settings
- `access_domain.json`: Domain policy for sip.unpod.tel
- `access_service.json`: Access service configuration with security settings
- `netalias_external.json`: External network alias (public IP)
- `netalias_FS_internal.json`: Internal FreeSWITCH network alias
- `netalias_FS_loopback.json`: Loopback network alias
- `sipprofile_FS_internal.json`: Internal SIP profile configuration
- `sipprofile_FS_loopback.json`: Loopback SIP profile configuration
- `gateway_carrier.json`: Gateway configuration for carrier routing
- `gateway_vapi.json`: Gateway configuration for PBX (vapi) routing
- `interconnection_carrier.json`: Outbound interconnection to carrier
- `interconnection_vapi.json`: Outbound interconnection to PBX
- `interconnection_loopback.json`: Loopback interconnection
- `routing_to_carrier.json`: Routing table for carrier calls
- `routing_to_vapi.json`: Routing table for PBX calls
- `media_class_pcma.json`: Media class configuration
- `capacity_class.json`: Capacity class configuration
- `cluster_members.json`: Cluster member configuration
- `directory_testuser.json`: Test user configuration

### Usage

1. Update the API_URL in `config.sh` to point to your LibreSBC API endpoint
2. Run the configuration script:
   ```bash
   chmod +x config.sh
   ./config.sh
   ```

### Security Notes

- The configuration includes anti-flooding, auth failure protection, and attack avoidance
- Default capacity is set to 5 CPS and 2000 concurrent calls
- All gateways use secure authentication with configurable credentials

### Customization

- Modify gateway credentials in `gateway_*.json` files
- Adjust capacity limits in `capacity_class.json`
- Update security thresholds in `access_service.json`
- Configure additional routing rules as needed
