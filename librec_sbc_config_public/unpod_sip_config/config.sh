#!/bin/bash

# LibreSBC Configuration Script for sip.unpod.tel
# Network: Public IP 159.65.154.134, Private IPs 10.47.0.8 (eth0), 10.122.0.7 (eth1)
# Carrier: 159.65.144.17, PBX vapi: 44.229.228.186

API_URL="https://159.65.154.134:8443/libreapi/"
HEADER="Content-Type:application/json"

echo "=== LibreSBC Configuration for sip.unpod.tel ==="
echo "Starting configuration deployment..."

echo "Step 1: Define Network Aliases"
echo "- Configuring external network alias (public IP)"
RESULT=$(curl -k -X POST -H ${HEADER} -d @./netalias_external.json ${API_URL}base/netalias 2>/dev/null)
[[ $RESULT == *"existent"* ]] && echo "  Already exists, skipping..." || echo "  $RESULT"

echo "- Configuring FS internal network alias"
RESULT=$(curl -k -X POST -H ${HEADER} -d @./netalias_FS_internal.json ${API_URL}base/netalias 2>/dev/null)
[[ $RESULT == *"existent"* ]] && echo "  Already exists, skipping..." || echo "  $RESULT"

echo "- Configuring FS loopback network alias"
RESULT=$(curl -k -X POST -H ${HEADER} -d @./netalias_FS_loopback.json ${API_URL}base/netalias 2>/dev/null)
[[ $RESULT == *"existent"* ]] && echo "  Already exists, skipping..." || echo "  $RESULT"

echo "Step 2: Define Domain and Access Service"
echo "- Configuring domain policy for sip.unpod.tel (may already exist)"
DOMAIN_RESULT=$(curl -k -X POST -H ${HEADER} -d @./access_domain.json ${API_URL}access/domain-policy 2>/dev/null)
if [[ $DOMAIN_RESULT == *"existent"* ]]; then
  echo "  Domain already exists, skipping..."
else
  echo "  $DOMAIN_RESULT"
fi

echo "- Configuring access service with security settings (may already exist)"
SERVICE_RESULT=$(curl -k -X POST -H ${HEADER} -d @./access_service.json ${API_URL}access/service 2>/dev/null)
if [[ $SERVICE_RESULT == *"domain is used"* ]]; then
  echo "  Access service already configured for domain, skipping..."
else
  echo "  $SERVICE_RESULT"
fi

echo "Step 3: Define Media and Capacity Classes"
echo "- Configuring media class (PCMA)"
RESULT=$(curl -k -X POST -H ${HEADER} -d @./media_class_pcma.json ${API_URL}class/media 2>/dev/null)
[[ $RESULT == *"existent"* ]] && echo "  Already exists, skipping..." || echo "  $RESULT"

echo "- Configuring capacity class"
RESULT=$(curl -k -X POST -H ${HEADER} -d @./capacity_class.json ${API_URL}class/capacity 2>/dev/null)
[[ $RESULT == *"existent"* ]] && echo "  Already exists, skipping..." || echo "  $RESULT"

echo "Step 4: Define Cluster Configuration"
echo "- Configuring cluster members"
RESULT=$(curl -k -X PUT -H ${HEADER} -d @./cluster_members.json ${API_URL}cluster 2>/dev/null)
echo "  $RESULT"

echo "Step 5: Create SIP Profiles"
echo "- Creating SIP profile for internal communication"
RESULT=$(curl -k -X POST -H ${HEADER} -d @./sipprofile_FS_internal.json ${API_URL}sipprofile 2>/dev/null)
[[ $RESULT == *"existent"* ]] && echo "  Already exists, skipping..." || echo "  $RESULT"

echo "- Creating SIP profile for loopback"
RESULT=$(curl -k -X POST -H ${HEADER} -d @./sipprofile_FS_loopback.json ${API_URL}sipprofile 2>/dev/null)
[[ $RESULT == *"existent"* ]] && echo "  Already exists, skipping..." || echo "  $RESULT"

sleep 2

echo "Step 6: Create Test User"
echo "- Creating test user directory entry"
RESULT=$(curl -k -X POST -H ${HEADER} -d @./directory_testuser.json ${API_URL}access/directory/user 2>/dev/null)
[[ $RESULT == *"existent"* ]] && echo "  Already exists, skipping..." || echo "  $RESULT"

echo "Step 7: Configure Gateways"
echo "- Creating gateway for carrier (159.65.144.17)"
RESULT=$(curl -k -X POST -H ${HEADER} -d @./gateway_carrier.json ${API_URL}base/gateway 2>/dev/null)
[[ $RESULT == *"existent"* ]] && echo "  Already exists, skipping..." || echo "  $RESULT"

echo "- Creating gateway for PBX vapi (44.229.228.186)"
RESULT=$(curl -k -X POST -H ${HEADER} -d @./gateway_vapi.json ${API_URL}base/gateway 2>/dev/null)
[[ $RESULT == *"existent"* ]] && echo "  Already exists, skipping..." || echo "  $RESULT"

echo "Step 8: Configure Interconnections"
echo "- Creating outbound interconnection to carrier"
RESULT=$(curl -k -X POST -H ${HEADER} -d @./interconnection_carrier.json ${API_URL}interconnection/outbound 2>/dev/null)
[[ $RESULT == *"existent"* ]] && echo "  Already exists, skipping..." || echo "  $RESULT"

echo "- Creating outbound interconnection to PBX vapi"
RESULT=$(curl -k -X POST -H ${HEADER} -d @./interconnection_vapi.json ${API_URL}interconnection/outbound 2>/dev/null)
[[ $RESULT == *"existent"* ]] && echo "  Already exists, skipping..." || echo "  $RESULT"

echo "Step 9: Configure Routing Tables"
echo "- Creating routing table for carrier calls"
RESULT=$(curl -k -X POST -H ${HEADER} -d @./routing_to_carrier.json ${API_URL}routing/table 2>/dev/null)
[[ $RESULT == *"existent"* ]] && echo "  Already exists, skipping..." || echo "  $RESULT"

echo "- Creating routing table for PBX vapi calls"
RESULT=$(curl -k -X POST -H ${HEADER} -d @./routing_to_vapi.json ${API_URL}routing/table 2>/dev/null)
[[ $RESULT == *"existent"* ]] && echo "  Already exists, skipping..." || echo "  $RESULT"

echo "- Creating loopback interconnection (after routing tables)"
RESULT=$(curl -k -X POST -H ${HEADER} -d @./interconnection_loopback.json ${API_URL}interconnection/inbound 2>/dev/null)
[[ $RESULT == *"existent"* ]] && echo "  Already exists, skipping..." || echo "  $RESULT"

echo "=== Configuration Complete ==="
echo "LibreSBC has been configured for sip.unpod.tel"
echo "Public IP: 159.65.154.134"
echo "Carrier: 159.65.144.17"
echo "PBX vapi: 44.229.228.186"
echo ""
echo "Please verify the configuration through the LibreSBC web interface."

exit 0
