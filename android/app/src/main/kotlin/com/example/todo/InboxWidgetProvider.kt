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

class InboxWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            val widgetData = HomeWidgetPlugin.getData(context)
            val jsonStr = widgetData.getString("widget_snapshot_inbox", null)
                ?: widgetData.getString("last_known_good_snapshot_inbox", null)

            val views = RemoteViews(context.packageName, R.layout.widget_today_medium)
            views.setTextViewText(R.id.widget_title, "Inbox")

            if (jsonStr != null) {
                try {
                    val json = JSONObject(jsonStr)
                    val count = json.optInt("totalCount", 0)
                    views.setTextViewText(R.id.widget_badge, count.toString())

                    val items = json.optJSONArray("items")
                    if (items != null) {
                        val item1 = if (items.length() > 0) items.getJSONObject(0).optString("title", "") else ""
                        val item2 = if (items.length() > 1) items.getJSONObject(1).optString("title", "") else ""
                        val item3 = if (items.length() > 2) items.getJSONObject(2).optString("title", "") else ""

                        views.setTextViewText(R.id.item_1, item1.ifEmpty { "Inbox is clear." })
                        views.setTextViewText(R.id.item_2, item2)
                        views.setTextViewText(R.id.item_3, item3)
                    }
                } catch (e: Exception) {
                    views.setTextViewText(R.id.item_1, "Open TaskMitra to refresh")
                }
            } else {
                views.setTextViewText(R.id.item_1, "Inbox is clear.")
            }

            val intent = Intent(Intent.ACTION_VIEW, Uri.parse("orbit://app/inbox")).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK
            }
            val pendingIntent = PendingIntent.getActivity(
                context,
                2,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_today_medium_root, pendingIntent)

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
