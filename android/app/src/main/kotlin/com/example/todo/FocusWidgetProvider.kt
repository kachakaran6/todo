package com.taskmitra.application

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.widget.RemoteViews
import org.json.JSONObject
import es.antonborri.home_widget.HomeWidgetPlugin

class FocusWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            val widgetData = HomeWidgetPlugin.getData(context)
            val jsonStr = widgetData.getString("widget_snapshot_focus", null)
                ?: widgetData.getString("last_known_good_snapshot_focus", null)

            val views = RemoteViews(context.packageName, R.layout.widget_focus)

            if (jsonStr != null) {
                try {
                    val json = JSONObject(jsonStr)
                    val focusObj = json.optJSONObject("focusTask")
                    if (focusObj != null) {
                        val title = focusObj.optString("title", "Choose one thing to focus on.")
                        views.setTextViewText(R.id.widget_focus_title, title)
                    } else {
                        val fallback = json.optString("fallbackMessage", "Choose one thing to focus on.")
                        views.setTextViewText(R.id.widget_focus_title, fallback)
                    }
                } catch (e: Exception) {
                    views.setTextViewText(R.id.widget_focus_title, "Choose one thing to focus on.")
                }
            } else {
                views.setTextViewText(R.id.widget_focus_title, "Choose one thing to focus on.")
            }

            val intent = Intent(Intent.ACTION_VIEW, Uri.parse("orbit://app/focus")).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK
            }
            val pendingIntent = PendingIntent.getActivity(
                context,
                3,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_focus_root, pendingIntent)

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
