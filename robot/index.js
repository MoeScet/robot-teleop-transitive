#!/usr/bin/env node
const mqtt = require('mqtt');
const state = { x: 0, y: 0, theta: 0, vLinear: 0, vAngular: 0 };
const UPDATE_RATE_HZ = 50;
const UPDATE_DT = 1.0 / UPDATE_RATE_HZ;
const STATE_PUBLISH_HZ = 10;
const MQTT_URL = 'mqtt://test-mosquitto:1883';
const CLIENT_ID = 'robot-' + Math.random().toString(16).substr(2, 8);
const BASE_TOPIC = 'test/robot1';

console.log('[Robot] Connecting to:', MQTT_URL);
const client = mqtt.connect(MQTT_URL, { clientId: CLIENT_ID, clean: true });

let physicsInterval, publishInterval;

function updatePhysics() {
  state.theta += state.vAngular * UPDATE_DT;
  while (state.theta > Math.PI) state.theta -= 2 * Math.PI;
  while (state.theta < -Math.PI) state.theta += 2 * Math.PI;
  state.x += state.vLinear * Math.cos(state.theta) * UPDATE_DT;
  state.y += state.vLinear * Math.sin(state.theta) * UPDATE_DT;
}

function publishState() {
  client.publish(`${BASE_TOPIC}/state`, JSON.stringify({
    position: { x: state.x, y: state.y, theta: state.theta },
    velocity: { linear: state.vLinear, angular: state.vAngular },
    timestamp: Date.now()
  }), { qos: 0, retain: true });
  console.log(`[Robot] x:${state.x.toFixed(2)} y:${state.y.toFixed(2)} θ:${(state.theta*180/Math.PI).toFixed(1)}° v:${state.vLinear.toFixed(2)} ω:${state.vAngular.toFixed(2)}`);
}

client.on('connect', () => {
  console.log('[Robot] ✓ Connected!');
  client.subscribe(`${BASE_TOPIC}/cmd`, () => console.log('[Robot] ✓ Subscribed'));
  physicsInterval = setInterval(updatePhysics, UPDATE_DT * 1000);
  publishInterval = setInterval(publishState, 1000 / STATE_PUBLISH_HZ);
  publishState();
  console.log('[Robot] ✓ Ready!');
});

client.on('message', (topic, payload) => {
  if (topic === `${BASE_TOPIC}/cmd`) {
    try {
      const cmd = JSON.parse(payload.toString());
      if (typeof cmd.linear === 'number' && typeof cmd.angular === 'number') {
        state.vLinear = cmd.linear;
        state.vAngular = cmd.angular;
        console.log(`[Robot] ← Command: v=${cmd.linear.toFixed(2)} ω=${cmd.angular.toFixed(2)}`);
      }
    } catch (err) {}
  }
});

client.on('error', (err) => console.error('[Robot] Error:', err.message));
process.on('SIGINT', () => { console.log('\n[Robot] Bye!'); process.exit(0); });
