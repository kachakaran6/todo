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

class TodayWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            val widgetData = HomeWidgetPlugin.getData(context)
            val jsonStr = widgetData.getString("widget_snapshot_today", null)
                ?: widgetData.getString("last_known_good_snapshot_today", null)

            val views = RemoteViews(context.packageName, R.layout.widget_today_small)

            if (jsonStr != null) {
                try {
                    val json = JSONObject(jsonStr)
                    val count = json.optInt("totalCount", 0)
                    views.setTextViewText(R.id.widget_badge, count.toString())

                    val items = json.optJSONArray("items")
                    if (items != null && items.length() > 0) {
                        val firstItem = items.getJSONObject(0)
                        views.setTextViewText(R.id.widget_task_title, firstItem.optString("title", "No tasks due today"))
                    } else {
                        val fallback = json.optString("fallbackMessage", "Today is clear.")
                        views.setTextViewText(R.id.widget_task_title, fallback)
                    }
                } catch (e: Exception) {
                    views.setTextViewText(R.id.widget_task_title, "Open TaskMitra to refresh")
                }
            } else {
                views.setTextViewText(R.id.widget_task_title, "Today is clear.")
            }

            // Launch app intent
            val intent = Intent(Intent.ACTION_VIEW, Uri.parse("orbit://app/today")).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK
            }
            val pendingIntent = PendingIntent.getActivity(
                context,
                0,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_today_small_root, pendingIntent)

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
