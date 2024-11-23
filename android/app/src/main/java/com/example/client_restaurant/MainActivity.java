package com.example.client_restaurant;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;
import vn.zalopay.sdk.ZaloPaySDK;
import vn.zalopay.sdk.Environment;
import vn.zalopay.sdk.listeners.PayOrderListener;
import android.content.Intent;
import android.os.Bundle;
import vn.zalopay.sdk.ZaloPayError;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.example.client_restaurant/zalopay";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        ZaloPaySDK.init(2554, Environment.SANDBOX);
        // Khởi tạo ZaloPay SDK trong onCreate
        new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler((call, result) -> {
                    if (call.method.equals("payOrder")) {
                        String zpTransToken = call.argument("zpTransToken");
                        payOrder(zpTransToken);
                        result.success(0);
                    } else {
                        result.notImplemented();
                    }
                });
    }

    private void payOrder(String zpTransToken) {
        if (ZaloPaySDK.getInstance() == null) {
            return;
        }
        ZaloPaySDK.getInstance().payOrder(this, zpTransToken, "merchant-deeplink", new MyZaloPayListener());
    }

    @Override
    public void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        ZaloPaySDK.getInstance().onResult(intent);
    }

    private void sendResultToFlutter(String status, String transactionId, String transToken) {
        new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), CHANNEL)
                .invokeMethod("paymentResult", status + ":" + transactionId + ":" + transToken);
    }

    private class MyZaloPayListener implements PayOrderListener {
        @Override
        public void onPaymentSucceeded(final String transactionId, final String transToken, final String appTransID) {
            sendResultToFlutter("success", transactionId, transToken);
        }

        @Override
        public void onPaymentCanceled(String zpTransToken, String appTransID) {
            sendResultToFlutter("canceled", zpTransToken, appTransID);
        }

        @Override
        public void onPaymentError(ZaloPayError zaloPayError, String zpTransToken, String appTransID) {
            sendResultToFlutter("error", zpTransToken, appTransID);
        }
    }
}
